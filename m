Return-Path: <linux-kernel-owner+w=401wt.eu-S934997AbXHHOOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997AbXHHOOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934688AbXHHOOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:14:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:14204 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934421AbXHHOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fZHxqQmtcfAEym/JZr0QZrfepkuY+mrUvglmcu0EcTaAUKJxuObn/4RIyCmOkPfx8NiB20fTRMQFoEVJNJM3UsSeAkZ01PkrJEkm5jdml8W++4RxDDvny+AZhYFBZsKwG1qOtQNdZADgD5LskUIr78CHP6skcH8LMHdsGuZrW6Q=
Message-ID: <46B9CFB3.6020402@gmail.com>
Date: Wed, 08 Aug 2007 23:14:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com> <46B9CE79.5030307@rtr.ca>
In-Reply-To: <46B9CE79.5030307@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Michael Sedkowski wrote:
>>> Dnia 07-08-2007, Wt o godzinie 03:43 +0900, Tejun Heo napisał(a):
>>>> Does emergency unload count increase
>>>> after each power down? 
>>> I think I got it.
>>> Using smartctl I've done a test and shut down, then repeted the test.
>>> The only values that where diffrent are temperatures and
>>> Hardware_ECC_Recovered which rised by 6 points.
>>> However I have no idea which of those is the "emergency count"...
>>> Full results in attachment.
>>>
>>> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age  
>>> Always       -       388
>>
>> I think this is the one.  You can test it by forcefully powering off the
>> machine (press power button for several secs or disconnect AC and
>> battery) and see whether the count increases.
> 
> FWIW, Tejun, with 2.6.22, my new Seagate 160GB SATA drive (notebook)
> increments the "Power-Off_Retract_Count" on each suspend-to-RAM operation.
> It does not do any double spin-up/spin-down things though.
> 
> What a mess.

Hmmm.. It shouldn't.  libata now issues STANDBYNOW prior to entering
STR.  Can you instrument code a bit and see whether it actually gets issued?

Thanks.

-- 
tejun
