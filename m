Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbXIHSLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbXIHSLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXIHSLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:11:38 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:37232 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXIHSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:11:37 -0400
X-Greylist: delayed 80122 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2007 14:11:36 EDT
Date: Sat, 8 Sep 2007 20:11:33 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: crash while playing bzflag
Message-ID: <20070908181133.GA4019@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070907195611.GA3259@steel.home> <46E1DB39.8090306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E1DB39.8090306@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3Cculz1E31xFw==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert, Sat, Sep 08, 2007 01:14:01 +0200:
> On 09/07/2007 03:56 PM, Alex Riesen wrote:
> > Kernel: v2.6.23-rc5+ (b21010ed6498391c0f359f2a89c907533fe07fec)
> > Ubuntu Feisty, Radeon R200 (9200) dual head, MergedFB, BZFlag in
> > OpenGL mode, frozen. That'll teach me playing games at home...
> > 
> > BUG: unable to handle kernel paging request at virtual address ffa85000
> >  printing eip:
> > c016eed1
> > *pde = 00005067
> > *pte = 00000000
> > Oops: 0000 [#1]
> > PREEMPT SMP 
> > Modules linked in: binfmt_misc nfs radeon drm nfsd exportfs lockd sunrpc fan firmware_class it87 hwmon_vid hwmon p4_clockmod speedstep_lib ipv6 sg sr_mod cdrom usb_storage snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device generic floppy snd ide_core intel_agp e100 uhci_hcd ehci_hcd soundcore snd_page_alloc agpgart evdev
> > CPU:    0
> > EIP:    0060:[__link_path_walk+2146/2867]    Not tainted VLI
> > EFLAGS: 00010287   (2.6.23-rc5-t #138)
> > EIP is at __link_path_walk+0x862/0xb33
> > eax: ffa85000   ebx: f0a4dd64   ecx: c0442130   edx: c1782d00
> > esi: eee51f30   edi: ffa85000   ebp: f0e49e40   esp: eee51de4
> > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > Process command-not-fou (pid: 2895, ti=eee51000 task=f08f1020 task.ti=eee51000)
> > Stack: f474c02c 00000101 f1db2d64 c016d3eb c1782d00 ffa85000 00000000 00000000 
> >        00000000 96ba5598 0000000b f474c021 c18eff00 f0e49e40 f08e1540 eee51f30 
> >        c1937c78 c18eff00 c016f1e6 f474c000 c1937c78 c18eff00 c180b180 f11a7600 
> > Call Trace:
> >  [do_lookup+79/323] do_lookup+0x4f/0x143
> >  [link_path_walk+68/179] link_path_walk+0x44/0xb3
> >  [_spin_unlock+5/28] _spin_unlock+0x5/0x1c
> >  [get_unused_fd_flags+198/208] get_unused_fd_flags+0xc6/0xd0
> >  [do_path_lookup+362/463] do_path_lookup+0x16a/0x1cf
> >  [__path_lookup_intent_open+69/117] __path_lookup_intent_open+0x45/0x75
> >  [path_lookup_open+32/37] path_lookup_open+0x20/0x25
> >  [open_namei+114/1364] open_namei+0x72/0x554
> >  [unmap_vmas+791/1240] unmap_vmas+0x317/0x4d8
> >  [do_filp_open+37/57] do_filp_open+0x25/0x39
> >  [_spin_unlock+5/28] _spin_unlock+0x5/0x1c
> >  [get_unused_fd_flags+198/208] get_unused_fd_flags+0xc6/0xd0
> >  [do_sys_open+68/192] do_sys_open+0x44/0xc0
> >  [sys_open+28/30] sys_open+0x1c/0x1e
> >  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
> >  [xfrm_bundle_ok+53/522] xfrm_bundle_ok+0x35/0x20a
> >  =======================
> > Code: f0 ff ff 0f 87 38 01 00 00 8b 46 1c 8b 44 86 20 89 44 24 14 31 ff 85 c0 0f 84 09 01 00 00 89 c7 3d 00 f0 ff ff 0f 87 f5 00 00 00 <80> 38 2f 0f 85 9f 00 00 00 89 f0 e8 38 e1 ff ff 64 a1 00 70 3f 
> > EIP: [__link_path_walk+2146/2867] __link_path_walk+0x862/0xb33 SS:ESP 0068:eee51de4
> 
> Whee...
> 
> here, in __vfs_follow_link:
> 
>         if (*link == '/') {   <================ link points to unmapped memory
>                 path_release(nd);
>                 if (!walk_init_root(link, nd))
>                         /* weird __emul_prefix() stuff did it */
>                         goto out;
>         }
> 
> inlined from __do_follow_link:
> 
>         if (!IS_ERR(cookie)) {
>                 char *s = nd_get_link(nd);
>                 error = 0;
>                 if (s)
>                         error = __vfs_follow_link(nd, s);
>                 if (dentry->d_inode->i_op->put_link)
>                         dentry->d_inode->i_op->put_link(dentry, nd, cookie);
>         }
> 
> __do_follow_link is inlined from do_follow_link
> 
> presumably inlined here:
> 
>                 if ((lookup_flags & LOOKUP_FOLLOW)
>                     && inode && inode->i_op && inode->i_op->follow_link) {
>                         err = do_follow_link(&next, nd);
>                         if (err)
>                                 goto return_err;
>                         inode = nd->dentry->d_inode;
>                 } else
> 
> What filesystem was this?

Presumably ext3 (because it is where command-not-found python script
is), but I usually have the following mounted:

/dev/sda9 on / type ext3 (rw,errors=remount-ro)
proc on /proc type proc (rw,noexec,nosuid,nodev)
/sys on /sys type sysfs (rw,noexec,nosuid,nodev)
varrun on /var/run type tmpfs (rw,noexec,nosuid,nodev,mode=0755)
varlock on /var/lock type tmpfs (rw,noexec,nosuid,nodev,mode=1777)
procbususb on /proc/bus/usb type usbfs (rw)
udev on /dev type tmpfs (rw,mode=0755)
devshm on /dev/shm type tmpfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda8 on /home type ext3 (rw)
/dev/sda1 on /media/sda1 type ext2 (rw)
/dev/sda2 on /media/sda2 type ext3 (rw)
/dev/sda5 on /media/sda5 type ext3 (rw)
/dev/sda7 on /media/sda7 type ext3 (rw)
nfsd on /proc/fs/nfsd type nfsd (rw)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)

