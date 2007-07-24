Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXGXAPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXGXAPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXGXAO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:14:58 -0400
Received: from gw.goop.org ([64.81.55.164]:43547 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbXGXAO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:14:57 -0400
Message-ID: <46A5444D.4080304@goop.org>
Date: Mon, 23 Jul 2007 17:14:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc>
In-Reply-To: <46A53396.2060902@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 23.07.2007 22:32 schrieb Jeremy Fitzhardinge:
>   
>> How much of this is modules?  Is the initrd probing for scsi/sata? 
>> Maybe the the vdso change is having an effect.
>>     
>
> Pretty much all of it is modules. The base system is openSUSE 10.2, and
> SuSE has a long habit of building everything as modules and putting the
> drivers needed for accessing the root filesystem into an initrd. I have
> fought it for a while but nowadays I'm playing along.
>
> So yes, all of ahci, pata_marvell, aic7xxx, jbd, dm_mod, ext3 are in
> fact modules in initrd. Would it help to try a kernel with some or all
> of these built in?
>
>   
>> Ooh, wait.  Do you have an old version of the Xen patches in place,
>> perhaps?
>>     
>
> In which place? I installed and successfully ran the Xen packages that
> came with openSUSE 10.2, so there is a 2.6.18 kernel with SuSE's Xen
> patches on the machine. But that shouldn't have any influence on the
> kernel.org kernels I build myself, should it?
>
>   
>>  Does drivers/block/Makefile have:
>>
>> obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
>>
>> (vs := xen-blkfront.o)
>>     
>
> It has the "+=" variant.
>
>   
>> Could you do a before and after booting with initcall_debug=1?
>>     
>
> "Before" and "after" meaning with CONFIG_XEN=n and CONFIG_XEN=y, I
> suppose. The resulting logs are a bit biggish, so I have put them on
> http://www.phnxsoft.com/~ts/linux/ for download. Let me know if you
> prefer having them mailed.

Well, it looks to me like it all falls over once it hits usermode;
everything up till then is identical (except for the Xen-related
initcalls which naturally don't exist in the non-Xen case).

I'm at a loss.  I don't know if there's some way to debug the initrd in
more detail.  I suspect that its failing all PCI probing, rather being a
specific SCSI/AHCI problem (since none of the other messages appear either).

Does the Xen case just hang, or reboot, or what?  The kernel messages
just appear to stop.  I'd expect it to at least complain about not
mounting the root filesystem or something.

Andi, any thoughts about how to debug the suse boot sequence?

    J
