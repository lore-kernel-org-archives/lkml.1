Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYGWW57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYGWW57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYGWW5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:57:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:52699 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWW5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gzfjeSCFLs5xdy7ZrbfTspOcttpgFFuNzuST9BRrRiiDVwOTlu6Vsl4WVG+ykkyAEk
         bnPvPCBcnXt56ZIt8gqWtQMEfeCoH2zWEDXmAtciSLZN1UysW5hjiRnwcFuSHW7ztK17
         +k8BN5KiFf88uqZbLVYSakIAP+gIO19RnnJcA=
Date: Wed, 23 Jul 2008 17:59:06 -0500
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
Message-ID: <20080723225820.GA4099@localhost>
References: <E1KLm0c-0002O6-RO@closure.thunk.org> <20080723214938.GA8034@mit.edu> <1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24.Jul'08 at  1:02:15 +0300, Tomas Winkler wrote:
> On Thu, Jul 24, 2008 at 12:49 AM, Theodore Tso <tytso@mit.edu> wrote:
> > On Wed, Jul 23, 2008 at 05:36:30PM -0400, Theodore Ts'o wrote:
> >>
> >> Is this a new one?  I don't think I've seen this on LKML....
> >
> > The context of this was I had just booted to 2.6.26-git9, noted with
> > annoyance that that the iwl4965 driver needed a new microcode file, so
> > I popped in my EVDO card, downloaded the firmware, moved the firmware
> > into place, and then got the above error message.
> >
> > I've since noted that it seems to be utterly refusing to associate
> > with my wireless access point.  This was working just fine with
> > 2.6.26-git6 kernel, so it looks like a recent regression?  I just
> > noticed someone else had recently complained about a similar "refusal
> > to associate" with the iwl3945 driver.
> 
> I'm not sure but this can be connected to what is described in thread:
> 'New: dhcp doesn't work with iwl4965'
> Tomas

I can't associate with the access point anymore, and it is a very
recent regression for me too (two or three days ago).

I have the new firmware iwlwifi-4965-2.ucode inside /lib/firmware
and when I try to connect (using the connect button in drakroam from
Mandriva) I get this (digged from the syslog):

Jul 23 13:46:01 localhost drakroam[3801]: running: /sbin/ifdown wlan0 daemon
Jul 23 13:46:01 localhost kernel: wlan0: associate with AP 00:1b:11:3c:f6:db
Jul 23 13:46:01 localhost ifplugd(wlan0)[3170]: Exiting.
Jul 23 13:46:04 localhost kernel: iwl4965 0000:06:00.0: PCI INT A disabled
Jul 23 13:46:04 localhost drakroam[3801]: running: /sbin/ifup wlan0 daemon
Jul 23 13:46:04 localhost kernel: iwl4965 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jul 23 13:46:04 localhost kernel: iwl4965 0000:06:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
Jul 23 13:46:04 localhost kernel: ------------[ cut here ]------------
Jul 23 13:46:04 localhost kernel: WARNING: at net/core/dev.c:1344 __netif_schedule+0x6f/0x80()
Jul 23 13:46:04 localhost kernel: Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss loop nvram snd_hda_intel snd_pcm snd_timer ohci1394 sg snd_page_alloc ieee1394 sky2 iwl4965 snd_hwdep sr_mod i2c_i801 evdev ide_disk ide_core ata_piix ahci libata dock sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Jul 23 13:46:04 localhost kernel: Pid: 1613, comm: iwl4965/0 Not tainted 2.6.26-06077-gc010b2f #147
Jul 23 13:46:04 localhost kernel:
Jul 23 13:46:04 localhost kernel: Call Trace:
Jul 23 13:46:04 localhost kernel:  [<ffffffff80237caf>] warn_on_slowpath+0x5f/0x80
Jul 23 13:46:04 localhost kernel:  [<ffffffff8042109f>] __netif_schedule+0x6f/0x80
Jul 23 13:46:04 localhost kernel:  [<ffffffff804a040a>] ieee80211_wake_queue+0x5a/0x70
Jul 23 13:46:04 localhost kernel:  [<ffffffff804a044f>] ieee80211_wake_queues+0x2f/0x50
Jul 23 13:46:04 localhost kernel:  [<ffffffffa00d2506>] iwl_bg_alive_start+0x216/0x4b0 [iwl4965]
Jul 23 13:46:04 localhost kernel:  [<ffffffffa00d22f0>] ? iwl_bg_alive_start+0x0/0x4b0 [iwl4965]
Jul 23 13:46:04 localhost kernel:  [<ffffffff802498d8>] run_workqueue+0x98/0x140
Jul 23 13:46:04 localhost kernel:  [<ffffffff8024a3e3>] worker_thread+0xa3/0x110
Jul 23 13:46:04 localhost kernel:  [<ffffffff8024d850>] ? autoremove_wake_function+0x0/0x40
Jul 23 13:46:04 localhost kernel:  [<ffffffff8024a340>] ? worker_thread+0x0/0x110
Jul 23 13:46:04 localhost kernel:  [<ffffffff8024d41d>] kthread+0x4d/0x80
Jul 23 13:46:04 localhost kernel:  [<ffffffff8020d249>] child_rip+0xa/0x11
Jul 23 13:46:04 localhost kernel:  [<ffffffff8024d3d0>] ? kthread+0x0/0x80
Jul 23 13:46:04 localhost kernel:  [<ffffffff8020d23f>] ? child_rip+0x0/0x11
Jul 23 13:46:04 localhost kernel:
Jul 23 13:46:04 localhost kernel: ---[ end trace 9c04ce6cf2b007a2 ]---
Jul 23 13:46:04 localhost kernel: Registered led device: iwl-phy0:radio
Jul 23 13:46:04 localhost kernel: Registered led device: iwl-phy0:assoc
Jul 23 13:46:04 localhost kernel: Registered led device: iwl-phy0:RX
Jul 23 13:46:04 localhost kernel: Registered led device: iwl-phy0:TX
Jul 23 13:46:04 localhost kernel: iwl4965: TX Power requested while scanning!

I am trying to bisect it, but I am facing some difficulties with compilation
problems and non-booting kernels.

In the thread Thomas Winkler pointed out the reporter says that using dhclient instead
of dhcp makes it work. However Mandriva uses dhclient and it does not work here.


