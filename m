Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbXHGGql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbXHGGql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXHGGqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:46:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:65298 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXHGGq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XXouSAij2GiWKCj5bTDUdJYfmat6oYBzdTmGNDgaSdVcSmjSj2Fmmjy5pkgZg31TE7nOD8vRwnLaqlIzqd47/EajWxz9AUvJ8RZTDobAlHLGmuGpvCvjmPXtqAwLO1gnAU/hNfvfbm1Rr8htZsfbvmL+tFruNeQ5CgVQBRY0Fno=
Message-ID: <46B8140E.3000509@gmail.com>
Date: Tue, 07 Aug 2007 15:41:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no> <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no> <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no> <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no> <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>
In-Reply-To: <46B7AF53.1040307@shaw.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> Michael Sedkowski wrote:
>>>> Hmmm... If the problem only shows up on nx6325, it might be that
>>>> ACPI is
>>>> pulling unnecessary stunt.  Please apply the attached patch and report
>>>> when the disk spins down and up.
>>> Disk spins down on "Pre-shutdown prepare" and then goes up and down on
>>> "Power down".
>>
>> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
>> it spins down the disk correctly.  Does emergency unload count increase
>> after each power down?  Also, please post the result of 'dmidecode'.
> 
> I know that my Compaq X1000-series laptop does do some kind of ACPI
> games with the disk on ACPI power off (I assume it is putting the disk
> in standby before power-off at least). It also does this if you boot
> into DOS, GRUB, etc. and then hit the power button. Could be if the disk
> is dumb enough to spin up for sync cache and standby when there is
> nothing to flush, and the kernel does its own standby, this could cause
> an extra spinup/down..

Yeah, that seems to be what's going on.  I don't think we have any other
choice than blacklisting those notebooks.  This is a mess.  How does the
other OS cope with this?

I'm thinking about using DMI vendor/product match to detect the affected
systems but I think it would be better to match the ACPI implementation
directly.  Is there a way to match specific ACPI implementation?

Thanks.

-- 
tejun
