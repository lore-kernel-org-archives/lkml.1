Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZD2NVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZD2NVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZD2NVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:21:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33844 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZD2NVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aoueqwCQOO2uFvDtI4wFLMVduIN4BcnnCPD3IlDGm8wUljjsAlHPTwUraIWd/hfSBY
         T0FoqphyOPVoMUZQ2TtWNYdXNZHYYxm2sStc0Q20CMRgovUaExfGTaM9+SjTvWwLr6R2
         8LL0C3x3Q2eVB7IUmgJ0DzfFcJEwLFKZppXRk=
MIME-Version: 1.0
In-Reply-To: <200904272335.33060.rjw@sisk.pl>
References: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com>
	 <200904272335.33060.rjw@sisk.pl>
Date: Wed, 29 Apr 2009 17:21:33 +0400
Message-ID: <208cbae30904290621m1fbf7bc5x27fa410a23ada3dc@mail.gmail.com>
Subject: Re: [warn_once] warning: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
From: Alexey Klimov <klimov.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 28, 2009 at 1:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 19 April 2009, Alexey Klimov wrote:
>> Hello all
>> When testing behaviour of radio-mr800 drvier when doing suspend/resume
>> to disk, using echo disk > /sys/power/state i have such warning in
>> dmesg(see below please).
>> Kernel is 30-rc2, up-to-date. If you need more information, feel free to ask.
>
> Can you please retest with the appended patch applied and report back?

Of course. I applied your patch against up-to-date sources (30-rc3),
and have more messages after resume:

ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
------------[ cut here ]------------
WARNING: at drivers/base/sys.c:405 sysdev_suspend+0xb6/0x21c()
Hardware name: TravelMate 2350
Interrupts enabled after cpufreq_suspend+0x0/0x113
Modules linked in: cpufreq_ondemand acpi_cpufreq snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss usbhid hid snd_intel8x0 snd_ac97_codec ipw2200 libipw
ac97_bus yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core
8139too lib80211 snd_timer mii ehci_hcd shpchp rtc_cmos rtc_core
sr_mod sg psmouse cdrom snd uhci_hcd pci_hotplug rtc_lib usbcore
thermal serio_raw soundcore ac snd_page_alloc i2c_i801 battery button
Pid: 1557, comm: bash Not tainted 2.6.30-rc3 #48
Call Trace:
 [<c011852d>] ? warn_slowpath+0x80/0xae
 [<c0102e0a>] ? apic_timer_interrupt+0x2a/0x30
 [<c01cc9d7>] ? rb_insert_color+0x93/0xb5
 [<c0150c88>] ? __insert_vmap_area+0x5e/0x96
 [<c0150e46>] ? alloc_vmap_area+0x186/0x192
 [<c01e90d9>] ? acpi_os_release_object+0x5/0x8
 [<c01061f5>] ? init_pit_timer+0x56/0xa1
 [<c012cbd1>] ? clockevents_set_mode+0x12/0x3b
 [<f8e071f5>] ? get_cur_val+0x78/0x87 [acpi_cpufreq]
 [<f8e0748e>] ? get_cur_freq_on_cpu+0x6e/0x84 [acpi_cpufreq]
 [<c025e1c8>] ? cpufreq_cpu_put+0x8/0x14
 [<c025eea6>] ? cpufreq_suspend+0x109/0x113
 [<c010d22f>] ? clear_local_APIC+0x18f/0x191
 [<c0230cb2>] ? sysdev_suspend+0xb6/0x21c
 [<c025ed9d>] ? cpufreq_suspend+0x0/0x113
 [<c01344ed>] ? hibernation_snapshot+0x8b/0x15b
 [<c0134649>] ? hibernate+0x8c/0x141
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c0133610>] ? state_store+0x4e/0x9a
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c01ca757>] ? kobj_attr_store+0x18/0x1c
 [<c018b8ed>] ? sysfs_write_file+0xb0/0xdd
 [<c018b83d>] ? sysfs_write_file+0x0/0xdd
 [<c015a5bb>] ? vfs_write+0x84/0xf7
 [<c015a6c6>] ? sys_write+0x3c/0x63
 [<c0102788>] ? sysenter_do_call+0x12/0x26
---[ end trace 723ae552bfab9043 ]---
PM: Creating hibernation image:
PM: Need to copy 14279 pages
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
PM: Restoring platform NVS memory
------------[ cut here ]------------
WARNING: at drivers/base/sys.c:469 sysdev_resume+0x27/0x81()
Hardware name: TravelMate 2350
Interrupts enabled while resuming system devices
Modules linked in: cpufreq_ondemand acpi_cpufreq snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss usbhid hid snd_intel8x0 snd_ac97_codec ipw2200 libipw
ac97_bus yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core
8139too lib80211 snd_timer mii ehci_hcd shpchp rtc_cmos rtc_core
sr_mod sg psmouse cdrom snd uhci_hcd pci_hotplug rtc_lib usbcore
thermal serio_raw soundcore ac snd_page_alloc i2c_i801 battery button
Pid: 1557, comm: bash Tainted: G        W  2.6.30-rc3 #48
Call Trace:
 [<c011852d>] ? warn_slowpath+0x80/0xae
 [<c01fffe2>] ? acpi_ns_check_predefined_names+0x46e/0x478
 [<c01ce800>] ? vsprintf+0xd/0xf
 [<c0118861>] ? try_acquire_console_sem+0x24/0x42
 [<c01fd3fe>] ? acpi_hw_read_port+0x23/0x71
 [<c01fd382>] ? acpi_hw_write_port+0x11/0x6a
 [<c01fc7c4>] ? acpi_hw_write_pm1_control+0xd/0x31
 [<c01fccbc>] ? acpi_leave_sleep_state_prep+0x8a/0xf7
 [<c01fc92e>] ? acpi_hw_register_read+0x4e/0xb2
 [<c0230ba2>] ? sysdev_resume+0x27/0x81
 [<c0134537>] ? hibernation_snapshot+0xd5/0x15b
 [<c0134649>] ? hibernate+0x8c/0x141
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c0133610>] ? state_store+0x4e/0x9a
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c01ca757>] ? kobj_attr_store+0x18/0x1c
 [<c018b8ed>] ? sysfs_write_file+0xb0/0xdd
 [<c018b83d>] ? sysfs_write_file+0x0/0xdd
 [<c015a5bb>] ? vfs_write+0x84/0xf7
 [<c015a6c6>] ? sys_write+0x3c/0x63
 [<c0102788>] ? sysenter_do_call+0x12/0x26
---[ end trace 723ae552bfab9044 ]---
------------[ cut here ]------------
WARNING: at drivers/base/sys.c:347 __sysdev_resume+0x38/0x9c()
Hardware name: TravelMate 2350
Interrupts enabled after (null)
Modules linked in: cpufreq_ondemand acpi_cpufreq snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss usbhid hid snd_intel8x0 snd_ac97_codec ipw2200 libipw
ac97_bus yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core
8139too lib80211 snd_timer mii ehci_hcd shpchp rtc_cmos rtc_core
sr_mod sg psmouse cdrom snd uhci_hcd pci_hotplug rtc_lib usbcore
thermal serio_raw soundcore ac snd_page_alloc i2c_i801 battery button
Pid: 1557, comm: bash Tainted: G        W  2.6.30-rc3 #48
Call Trace:
 [<c011852d>] ? warn_slowpath+0x80/0xae
 [<c01fffe2>] ? acpi_ns_check_predefined_names+0x46e/0x478
 [<c01ce800>] ? vsprintf+0xd/0xf
 [<c0118861>] ? try_acquire_console_sem+0x24/0x42
 [<c01fd3fe>] ? acpi_hw_read_port+0x23/0x71
 [<c01fd382>] ? acpi_hw_write_port+0x11/0x6a
 [<c01fc7c4>] ? acpi_hw_write_pm1_control+0xd/0x31
 [<c0230b17>] ? __sysdev_resume+0x38/0x9c
 [<c0230bca>] ? sysdev_resume+0x4f/0x81
 [<c0134537>] ? hibernation_snapshot+0xd5/0x15b
 [<c0134649>] ? hibernate+0x8c/0x141
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c0133610>] ? state_store+0x4e/0x9a
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c01ca757>] ? kobj_attr_store+0x18/0x1c
 [<c018b8ed>] ? sysfs_write_file+0xb0/0xdd
 [<c018b83d>] ? sysfs_write_file+0x0/0xdd
 [<c015a5bb>] ? vfs_write+0x84/0xf7
 [<c015a6c6>] ? sys_write+0x3c/0x63
 [<c0102788>] ? sysenter_do_call+0x12/0x26
---[ end trace 723ae552bfab9045 ]---
------------[ cut here ]------------
WARNING: at drivers/base/sys.c:354 __sysdev_resume+0x7f/0x9c()
Hardware name: TravelMate 2350
Interrupts enabled after cpufreq_resume+0x0/0x115
Modules linked in: cpufreq_ondemand acpi_cpufreq snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss usbhid hid snd_intel8x0 snd_ac97_codec ipw2200 libipw
ac97_bus yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core
8139too lib80211 snd_timer mii ehci_hcd shpchp rtc_cmos rtc_core
sr_mod sg psmouse cdrom snd uhci_hcd pci_hotplug rtc_lib usbcore
thermal serio_raw soundcore ac snd_page_alloc i2c_i801 battery button
Pid: 1557, comm: bash Tainted: G        W  2.6.30-rc3 #48
Call Trace:
 [<c011852d>] ? warn_slowpath+0x80/0xae
 [<c011452e>] ? wakeup_preempt_entity+0xc3/0xe9
 [<c01145d9>] ? check_preempt_wakeup+0x85/0xab
 [<c0125c00>] ? wake_up_bit+0xc/0x5c
 [<c0114e4d>] ? __wake_up_common+0x2d/0x52
 [<c0114e81>] ? __wake_up+0xf/0x15
 [<c0123370>] ? __queue_work+0x43/0x49
 [<c025e1c8>] ? cpufreq_cpu_put+0x8/0x14
 [<c025ed94>] ? cpufreq_resume+0x10c/0x115
 [<c0230b5e>] ? __sysdev_resume+0x7f/0x9c
 [<c025ec88>] ? cpufreq_resume+0x0/0x115
 [<c0230bca>] ? sysdev_resume+0x4f/0x81
 [<c0134537>] ? hibernation_snapshot+0xd5/0x15b
 [<c0134649>] ? hibernate+0x8c/0x141
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c0133610>] ? state_store+0x4e/0x9a
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c01ca757>] ? kobj_attr_store+0x18/0x1c
 [<c018b8ed>] ? sysfs_write_file+0xb0/0xdd
 [<c018b83d>] ? sysfs_write_file+0x0/0xdd
 [<c015a5bb>] ? vfs_write+0x84/0xf7
 [<c015a6c6>] ? sys_write+0x3c/0x63
 [<c0102788>] ? sysenter_do_call+0x12/0x26
---[ end trace 723ae552bfab9046 ]---
------------[ cut here ]------------
WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
Hardware name: TravelMate 2350
hres_timers_resume() called with IRQs enabled!Modules linked in:
cpufreq_ondemand acpi_cpufreq snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
usbhid hid snd_intel8x0 snd_ac97_codec ipw2200 libipw ac97_bus
yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core 8139too
lib80211 snd_timer mii ehci_hcd shpchp rtc_cmos rtc_core sr_mod sg
psmouse cdrom snd uhci_hcd pci_hotplug rtc_lib usbcore thermal
serio_raw soundcore ac snd_page_alloc i2c_i801 battery button
Pid: 1557, comm: bash Tainted: G        W  2.6.30-rc3 #48
Call Trace:
 [<c011852d>] ? warn_slowpath+0x80/0xae
 [<c011452e>] ? wakeup_preempt_entity+0xc3/0xe9
 [<c0103f7b>] ? handle_irq+0xb/0x64
 [<c011b9f2>] ? irq_exit+0x2c/0x4e
 [<c0103ccb>] ? do_IRQ+0x53/0x63
 [<c012aaa5>] ? getnstimeofday+0x4f/0xcc
 [<c010d023>] ? lapic_next_event+0x13/0x16
 [<c012cbb1>] ? clockevents_program_event+0xc2/0xd0
 [<c012d6bf>] ? tick_dev_program_event+0x1e/0x81
 [<c012d761>] ? tick_program_event+0xf/0x11
 [<c01288ba>] ? notifier_call_chain+0x2a/0x47
 [<c0127ec2>] ? hres_timers_resume+0x24/0x38
 [<c012a1b9>] ? timekeeping_resume+0xcd/0xd2
 [<c0230af0>] ? __sysdev_resume+0x11/0x9c
 [<c0230bca>] ? sysdev_resume+0x4f/0x81
 [<c0134537>] ? hibernation_snapshot+0xd5/0x15b
 [<c0134649>] ? hibernate+0x8c/0x141
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c0133610>] ? state_store+0x4e/0x9a
 [<c01335c2>] ? state_store+0x0/0x9a
 [<c01ca757>] ? kobj_attr_store+0x18/0x1c
 [<c018b8ed>] ? sysfs_write_file+0xb0/0xdd
 [<c018b83d>] ? sysfs_write_file+0x0/0xdd
 [<c015a5bb>] ? vfs_write+0x84/0xf7
 [<c015a6c6>] ? sys_write+0x3c/0x63
 [<c0102788>] ? sysenter_do_call+0x12/0x26
---[ end trace 723ae552bfab9047 ]---
ACPI: Waking up from system sleep state S4

I can do more testing if you need, just ask.

> ---
>
>    PM: Warn if interrupts are enabled during suspend-resume of sysdevs
>
>    Sysdevs have to be suspended and resumed with interrupts disabled and
>    things usually break in a way that's difficult to debug if one of
>    sysdev drivers enables interrupts by mistake during suspend or
>    resume.  Add extra checks that will generate warnings in such cases.
>
>    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 3236b43..9742a78 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -343,11 +343,15 @@ static void __sysdev_resume(struct sys_device *dev)
>        /* First, call the class-specific one */
>        if (cls->resume)
>                cls->resume(dev);
> +       WARN_ONCE(!irqs_disabled(),
> +               "Interrupts enabled after %pF\n", cls->resume);
>
>        /* Call auxillary drivers next. */
>        list_for_each_entry(drv, &cls->drivers, entry) {
>                if (drv->resume)
>                        drv->resume(dev);
> +               WARN_ONCE(!irqs_disabled(),
> +                       "Interrupts enabled after %pF\n", drv->resume);
>        }
>  }
>
> @@ -377,6 +381,9 @@ int sysdev_suspend(pm_message_t state)
>        if (ret)
>                return ret;
>
> +       WARN_ONCE(!irqs_disabled(),
> +               "Interrupts enabled while suspending system devices\n");
> +
>        pr_debug("Suspending System Devices\n");
>
>        list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
> @@ -393,6 +400,9 @@ int sysdev_suspend(pm_message_t state)
>                                        if (ret)
>                                                goto aux_driver;
>                                }
> +                               WARN_ONCE(!irqs_disabled(),
> +                                       "Interrupts enabled after %pF\n",
> +                                       drv->suspend);
>                        }
>
>                        /* Now call the generic one */
> @@ -400,6 +410,9 @@ int sysdev_suspend(pm_message_t state)
>                                ret = cls->suspend(sysdev, state);
>                                if (ret)
>                                        goto cls_driver;
> +                               WARN_ONCE(!irqs_disabled(),
> +                                       "Interrupts enabled after %pF\n",
> +                                       cls->suspend);
>                        }
>                }
>        }
> @@ -452,6 +465,9 @@ int sysdev_resume(void)
>  {
>        struct sysdev_class *cls;
>
> +       WARN_ONCE(!irqs_disabled(),
> +               "Interrupts enabled while resuming system devices\n");
> +
>        pr_debug("Resuming System Devices\n");
>
>        list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
>

-- 
Best regards, Klimov Alexey
