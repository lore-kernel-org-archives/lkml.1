Return-Path: <linux-kernel-owner+w=401wt.eu-S2992770AbXDRPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992770AbXDRPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXDRPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:25:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:18578 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992770AbXDRPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=m3angHtIUJ+OaUW3JLtPE+7KjhMxdDtNwmmX+OQ+guofNocHMkG8RVKym8BqaRMulr0dPssKl7T4gYMcBAND40w2vvFHxQRqirDtnbBeDX35/o70o2mYY6f440VNJgBywfkiQq/burh41WrBqlOrtbgeai7UkhcLnW0d7jUYP3s=
Message-ID: <46263859.2060309@gmail.com>
Date: Thu, 19 Apr 2007 00:25:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com>	<20070418140346.636879a1@the-village.bc.nu>	<46262C0E.9000103@rtr.ca> <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca>
In-Reply-To: <46263650.3080705@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Alan Cox wrote:
>>> +        if (dev->needs_flush && ata_try_flush_cache(dev)) {
>>>              return ata_scsi_flush_xlat;
>>> +            dev->needs_flush = 0;
>>
>> Works better if you swap the dev-> and return lines
> 
> Heh, yeah, I noticed that!
> 
> Here it is, *tested* now, with another fix.
> 
> It would be nice if somebody who can hear the "pop" would also test this,
> as it will confirm that this is a complete fix for the problem.

You'll probably be able to here the "pop" on sleep-to-disk.

> My "pop" drives are busy elsewhere right now.
> 
> Tejun might use something like this, or do something better in libata-core,
> but it's still helpful to have confirmation that we're on the right track.

Yeap, I was thinking about more conservative check but this looks simple
and sweet.  :-)

-- 
tejun
