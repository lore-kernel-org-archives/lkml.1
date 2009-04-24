Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZDXIcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZDXIcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbZDXIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:32:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:38270 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbZDXIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LqM0QS1iasukqTWZxRLijyH426nubEVWDP0db9ZsM1b/HxC3sQsDwsJ4kYWkM2oCH5
         6U7OT7oUqM/ZPmu7SVWLlW2m+OnfbOBG7ZL7HDv+FwkZFJgPcc99XYiDJwcA60HtavMM
         0YHWs9drjX7B4dZGm6BDsCzOVexJGxoeBQSY0=
MIME-Version: 1.0
In-Reply-To: <20090424073115.GF24912@elte.hu>
References: <c4e36d110904170213q24c2688ag9bcaa8562dddaa3f@mail.gmail.com>
	 <20090423130930.50a6c9db.akpm@linux-foundation.org>
	 <20090423203945.GA3890@kroah.com> <20090424073115.GF24912@elte.hu>
Date: Fri, 24 Apr 2009 10:32:17 +0200
Message-ID: <b647ffbd0904240132y4720aa43n18573412d05c7a13@mail.gmail.com>
Subject: Re: WARNING: at fs/sysfs/group.c:138 sysfs_remove_group
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Ingo Molnar <mingo@elte.hu>:
>
> (more people Cc:-ed - some microcode driver sysdev badness)
>
> * Greg KH <greg@kroah.com> wrote:
>
>> On Thu, Apr 23, 2009 at 01:09:30PM -0700, Andrew Morton wrote:
>> > On Fri, 17 Apr 2009 11:13:08 +0200
>> > Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>> >
>> > > Hi
>> > >
>> > >
>> > > When I've checked  2.6.30-rc2 kernel and  I've got among other errors
>> > > with Wifi message below.
>> > > As I've noticed - some people were reporting this problem already earlier:
>> > >
>> > > http://www.gossamer-threads.com/lists/linux/kernel/1058276?page=last
>> > >
>> > > But for me - it started with 2.6.30-rc kernels.
>> > > I've T61, 4GB, C2D, X86_64.
>> > >
>> > >
>> > >
>> > > Zdenek
>> > >
>> > >
>> > > platform microcode: firmware: requesting intel-ucode/06-0f-0a
>> > > platform microcode: firmware: requesting intel-ucode/06-0f-0a
>> >
>> > Lots of people are reporting this.  One person reported that each
>> > attempt takes 60 seconds, thus delaying boot be several minutes.
>> >
>> > > Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> > > ------------[ cut here ]------------
>> > > WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x10b/0x110()
>> > > Hardware name: 6464CTO
>> > > sysfs group ffffffffa038d900 not found for kobject 'cpu0'
>> > > Modules linked in: microcode(-) binfmt_misc dm_mirror dm_region_hash
>> > > dm_log dm_mod kvm_intel kvm i915 dr
>> > > m i2c_algo_bit uinput btusb bluetooth arc4 ecb cryptomgr aead
>> > > pcompress thinkpad_acpi snd_hda_codec_analog crypto_blkcipher
>> > > crypto_hash snd_hda_intel cry
>> > > pto_algapi snd_hda_codec iwl3945 snd_seq_oss iwlcore
>> > > snd_seq_midi_event mac80211 snd_seq rfkill backlight i2c_i801 psmouse
>> > > intel_agp snd_seq_device snd_p
>> > > cm_oss rtc_cmos rtc_core sr_mod cdrom i2c_core sdhci_pci sdhci
>> > > mmc_core serio_raw led_class iTCO_wdt iTCO_vendor_support nvram
>> > > cfg80211 snd_mixer_oss e10
>> > > 00e rtc_lib snd_pcm snd_timer snd evdev soundcore button ac battery
>> > > snd_page_alloc uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
>> > > scsi_wait_scan]
>> > > Pid: 1983, comm: rmmod Not tainted 2.6.30-rc2-00076-g3ee8da8 #51
>> > > Call Trace:
>> > >  [<ffffffff802434bf>] warn_slowpath+0xaf/0xf0
>> > >  [<ffffffff8039c3dd>] ? kobject_release+0x5d/0xa0
>> > >  [<ffffffff80333f7b>] sysfs_remove_group+0x10b/0x110
>> > >  [<ffffffffa038b3f8>] mc_sysdev_remove+0x38/0x50 [microcode]
>> > >  [<ffffffff8043c08f>] sysdev_driver_unregister+0x5f/0xa0
>> > >  [<ffffffffa038bee8>] microcode_exit+0x39/0x65 [microcode]
>> > >  [<ffffffff8026e974>] sys_delete_module+0x1b4/0x280
>> > >  [<ffffffff8039ff18>] ? __up_write+0xd8/0x150
>> > >  [<ffffffff8053e35f>] ? trace_hardirqs_on_thunk+0x3a/0x3c
>> > >  [<ffffffff8020c19b>] system_call_fastpath+0x16/0x1b
>> >
>> > ugh, where to start?
>> >
>> > sysdev_driver_register() calls all the ->add methods and cheerily drops
>> > their return codes on the floor.  Consequently
>> > sysdev_driver_unregister() will call the ->remove method on objects
>> > which were not successfully add()ed.
>>
>> Ugh, the sysdev code sucks so badly it's not funny.  It's next on my
>> chopping block for cleanups, need to still do some driver core rework
>> first though :(
>>
>> > mc_sysdev_add() will return an error if microcode_init_cpu() failed but
>> > fails to remove its attr_group in that case.  So if
>> > sysdev_driver_register()/sysdev_driver_unregister() get fixed,
>> > microcode will misbehave.
>> >
>> > This patch:
>> >
>> > : commit af5c820a3169e81af869c113e18ec7588836cd50
>> > : Author:     Rusty Russell <rusty@rustcorp.com.au>
>> > : AuthorDate: Wed Mar 11 16:32:36 2009 +1030
>> > : Commit:     Ingo Molnar <mingo@elte.hu>
>> > : CommitDate: Wed Mar 18 13:50:47 2009 +0100
>> > :
>> > :     x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c
>> > :
>> >
>> > attempted to fix things up a bit:
>> >
>> > : @@ -379,8 +390,11 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
>> > :         if (err)
>> > :                 return err;
>> > :
>> > : -       microcode_init_cpu(cpu);
>> > : -       return 0;
>> > : +       err = microcode_init_cpu(cpu);
>> > : +       if (err)
>> > : +               sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>> > : +
>> > : +       return err;
>> > :  }
>> > :
>> > :  static int mc_sysdev_remove(struct sys_device *sys_dev)
>> >
>> > But it seems that the sysfs_remove_group() later got removed again.
>>
>> So, this is a microcode specific issue?
>
> Hm, it really doesnt do anything fancy. I've Cc:-ed a few more
> folks. There's a patch to try in this thread on lkml:

The following commit addresses this issue.

0917798d82212f884fff650e7e520de3b438f947

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0917798d82212f884fff650e7e520de3b438f947

>
>        Ingo
>

-- 
Best regards,
Dmitry Adamushko
