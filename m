Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYDSGeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYDSGeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYDSGdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:33:53 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:51091 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYDSGdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:content-transfer-encoding:date:message-id:mime-version:x-mailer;
        b=fzLQPr4Md1aKYkYMsAkYS0nATal5+Qj6VfOmXa8mlsycazuVDJPcjl59MoQyXkcMcB4dmLR1AutqKZ4MUs96f+L+w4TIQGp3v6Xrp9D8zV/89+LirFMlY/mr4xFlF2lz0tzvmBJOHfrS0SN9hXyyH5xPjzfzrpQVNgjiI4kIL7M=
Subject: Re: 2.6.25-mm1
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080418212934.bbe84ee2.akpm@linux-foundation.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080419021343.GA3503@nineveh.local>
	 <20080418200237.b5a9e805.akpm@linux-foundation.org>
	 <20080419041429.GA8508@anvil.corenet.prv>
	 <20080418212934.bbe84ee2.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Apr 2008 02:33:39 -0400
Message-Id: <1208586819.32485.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 21:29 -0700, Andrew Morton wrote:
> On Sat, 19 Apr 2008 00:14:29 -0400 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Fri, Apr 18, 2008 at 08:02:37PM -0700, Andrew Morton wrote:
> > > On Fri, 18 Apr 2008 22:13:43 -0400 Joseph Fannin <jfannin@gmail.com> wrote:
> > > 
> > > > On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
> > > > >
> > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 
> > > > 
> > > > I've been seeing the following backtraces since 2.6.25-rc8-mm1 -- at
> > > > least, since that's the earliest -mm I've built in a while.  I don't
> > > > get the same in mainline.
> > > > 
> > > > No idea who to CC:
> > > 
> > > I have a few ideas.
> > > 
> > > >  I've sat on this report long enough.
> > > 
> > > Thanks for the report.
> > > 
> > > > I'm going to send a few different reports in separate mails, so I'll
> > > > put my dmesg and .config up on a server:
> > > > 
> > > > http://home.columbus.rr.com/jfannin3/dmesg.txt
> > > > http://home.columbus.rr.com/jfannin3/config-2.6.25-mm1.txt
> > > > 
> > > > [  451.915553] sysfs: duplicate filename 'pcspkr' can not be created
> > > > [  451.915731] ------------[ cut here ]------------
> > > > [  451.915851] WARNING: at fs/sysfs/dir.c:427 sysfs_add_one+0x85/0xe0()
> > > > [  451.915981] Modules linked in: snd_pcsp(+) ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi psmouse snd_rawmidi serio_raw snd_seq_midi_event snd_seq button i2c_viapro snd_timer snd_seq_device pcspkr i2c_core snd snd_page_alloc via686a shpchp pci_hotplug parport_pc parport via_agp agpgart soundcore evdev sg sr_mod cdrom sd_mod 8139cp aic7xxx  scsi_transport_spi scsi_mod 8139too mii uhci_hcd usbcore raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal processor fan fuse ext4dev mbcache jbd2 crc16
> > > > [  451.918960] Pid: 2740, comm: modprobe Tainted: G        W 2.6.25-mm1 #7
> > > > [  451.929271]  [<c0130fa9>] warn_on_slowpath+0x59/0x80
> > > > [  451.929500]  [<c0132400>] ? vprintk+0x2f0/0x4a0
> > > > [  451.929723]  [<c0356adc>] ? _spin_unlock+0x2c/0x50
> > > > [  451.929918]  [<c01c6a7a>] ? ifind+0x4a/0xa0
> > > > [  451.930126]  [<c0155216>] ? trace_hardirqs_on_caller+0x16/0x150
> > > > [  451.930334]  [<c015535b>] ? trace_hardirqs_on+0xb/0x10
> > > > [  451.930534]  [<c01325d0>] ? printk+0x20/0x30
> > > > [  451.930727]  [<c01fcc45>] sysfs_add_one+0x85/0xe0
> > > > [  451.930900]  [<c01fd89e>] create_dir+0x4e/0xb0
> > > > [  451.931064]  [<c01fd930>] sysfs_create_dir+0x30/0x50
> > > > [  451.931291]  [<c0356adc>] ? _spin_unlock+0x2c/0x50
> > > > [  451.931485]  [<c023dac6>] kobject_add_internal+0xb6/0x190
> > > > [  451.931656]  [<c023dc22>] ? kobject_set_name_vargs+0x32/0x40
> > > > [  451.931857]  [<c023dc8a>] kobject_add_varg+0x5a/0x60
> > > > [  451.932022]  [<c023e12f>] kobject_init_and_add+0x2f/0x40
> > > > [  451.932188]  [<c02a3e44>] bus_add_driver+0x94/0x250
> > > > [  451.932364]  [<c02a5062>] driver_register+0x42/0xf0
> > > > [  451.932533]  [<c02a6c56>] platform_driver_register+0x66/0x70
> > > > [  451.932702]  [<cc04b02a>] pcsp_init+0x2a/0x2c [snd_pcsp]
> > > > [  451.932877]  [<c015e137>] sys_init_module+0x87/0x1a0
> > > > [  451.933043]  [<c0155216>] ? trace_hardirqs_on_caller+0x16/0x150
> > > > [  451.933246]  [<c024314c>] ? trace_hardirqs_on_thunk+0xc/0x10
> > > > [  451.933453]  [<c0104077>] sysenter_past_esp+0x78/0xc5
> > > 
> > > Yes, there have been lots of these lately.  I expect some of them _will_ go
> > > into mainline and they'll then slowly get weeded out.
> > > 
> > 
> > It looks like it is coming from snd_pcsp module from alsa tree.
> 
> Ah, OK.  More cc's.
> 
> > 
> > Cool things there:
> > 
> > +#ifdef CONFIG_DEBUG_PAGEALLOC
> > +	/* Well, CONFIG_DEBUG_PAGEALLOC makes the sound horrible. Lets
> > alert */
> > +	printk(KERN_WARNING
> > +	       "PCSP: Warning, CONFIG_DEBUG_PAGEALLOC is enabled!\n"
> > +	       "You have to disable it if you want to use the PC-Speaker
> > "
> > +	       "driver.\n"
> > +	       "Unless it is disabled, enjoy the horrible, distorted "
> > +	       "and crackling noise.\n");
> > +#endif
> 
> heh.
> 
> CONFIG_DEBUG_PAGEALLOC is a very heavy consumer of CPU cycles.  I'm not
> surprised that it would whack what I presume to be a very latency-sensitive
> driver.

Um...

[jhf@Susa ~]$ uname -a
Linux Susa 2.6.25-mm1 #7 SMP PREEMPT Fri Apr 18 17:05:14 EDT 2008 i686
GNU/Linux
[jhf@Susa ~]$ zgrep PAGEALLOC /proc/config.gz
# CONFIG_DEBUG_PAGEALLOC is not set
[jhf@Susa ~]$

I thought that might have snuck in as =y, but it didn't.

--
Joseph Fannin
jfannin@gmail.com

