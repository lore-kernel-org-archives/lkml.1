Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXCOVoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXCOVoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXCOVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:44:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63412 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXCOVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sQop+2Y9wNUD0AjHzJK25CENYvsgIfMNe18v/lxiXz9Alq2uvhHy02dzxw0QHEblc0pAPDgM7BRpTCj63HIQ4zJ0CBmG9hqFHzZcNeMmBhK4SKihoYJvLL4rdkTqzjcRTyExS6Lk3h1M5AbdkqZ3yCu+LiPqyqXL4qba/bzVKWc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 10/13] sl82c105: add ->speedproc support
Date: Thu, 15 Mar 2007 22:51:18 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200703102209.59918.bzolnier@gmail.com> <45F551E5.8010904@ru.mvista.com> <45F86058.6090509@ru.mvista.com>
In-Reply-To: <45F86058.6090509@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152251.18615.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 14 March 2007, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >>> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>> [PATCH] sl82c105: add ->speedproc support
> 
> >>>> * add sl82c105_tunepio() wrapper for sl82c105_tune_drive()
> >>>>  (just to get the error value)
> 
> >>>> * add sl82c105_tune_chipset() (->speedproc method) for setting
> >>>>  transfer mode
> 
> >>>    Thanks for the patch!
> 
> >>>  > Index: b/drivers/ide/pci/sl82c105.c
> 
> >>>> ===================================================================
> >>>> --- a/drivers/ide/pci/sl82c105.c
> >>>> +++ b/drivers/ide/pci/sl82c105.c
> 
> > [...]
> 
> >>>> @@ -114,17 +114,45 @@ static void sl82c105_tune_drive(ide_driv
> >>>>      */
> >>>>     drive->io_32bit = 1;
> >>>>     drive->unmask    = 1;
> >>>> +
> >>>> +    return 0;
> >>>> +}
> >>>> +
> >>>> +static void sl82c105_tune_drive(ide_drive_t *drive, u8 pio)
> >>>> +{
> >>>> +    /*
> >>>> +     * TODO: find best PIO mode and set device speed here
> >>>> +     *       (requires adding helper function for getting PIO cycle 
> >>>> time)
> >>>> +     */
> 
> >>>   I thought we were doing it by calling ide_get_best_pio_mode() above...
> 
> >> We are also using ide_get_best_pio_mode() to get PIO cycle time
> >> so we can't move it here ATM.
> 
> >   I've found/used quite convenient workaround for that -- return PIO 
> > mode actually selected from xxx_tune_pio(), then call 
> > ide_config_drive_speed() from the real tuneproc() method.
> 
>     Works like charm with ignoring the result, since ide_get_best_pio_mode() 
> returns the same explicit mode as was passed to it -- so is good for the 
> speedproc() methods also...
> 
> >>>> +    (void)sl82c105_tunepio(drive, pio);
> 
> >>>    Erm, I thought afterwards that I vainly folded one into another. I 
> >>> think it's worth moving those io_32bit and unmask flag assignments 
> >>> above back there... May also recast my patch. :-)
> 
> >> Moving them to ->init_hwif where they belong would be even better... ;-)
> 
> >    Well, I wasn't sure where they belong... :-)
> >    So, OK to recast that patch?
> 
>    Recasted it and reworked your patch atop of it (adding MWDMA 0/1 support as 
> a bonus! :-) -- now need to conduct some testing on a remote target...

Great. :)

Bart
