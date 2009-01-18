Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbZARQYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbZARQYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbZARQY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:24:29 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:55274 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758230AbZARQY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:24:28 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in hres_timers_resume
Date: Sun, 18 Jan 2009 19:23:40 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200901181642.00886.arvidjaar@mail.ru> <1232293169.5204.14.camel@laptop>
In-Reply-To: <1232293169.5204.14.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2028459.CyzrO676g1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901181923.43560.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2028459.CyzrO676g1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 18 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 18:39:29 Peter Zijlstra wro=
te:
> On Sun, 2009-01-18 at 16:41 +0300, Andrey Borzenkov wrote:
> > [17854.688347] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [17854.688347] [ INFO: inconsistent lock state ]
> > [17854.688347] 2.6.29-rc2-1avb #1
> > [17854.688347] ---------------------------------
> > [17854.688347] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> > [17854.688347] pm-suspend/18240 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [17854.688347]  (&cpu_base->lock){++..}, at: [<c0136fcc>]
> > retrigger_next_event+0x5c/0xa0 [17854.688347] {in-hardirq-W} state
> > was registered at:
> > [17854.688347]   [<c01443cd>] __lock_acquire+0x79d/0x1930
> > [17854.688347]   [<c01455bc>] lock_acquire+0x5c/0x80
> > [17854.688347]   [<c03092e5>] _spin_lock+0x35/0x70
> > [17854.688347]   [<c0136e61>] hrtimer_run_queues+0x31/0x140
> > [17854.688347]   [<c0128d98>] run_local_timers+0x8/0x20
> > [17854.688347]   [<c0128dd3>] update_process_times+0x23/0x60
> > [17854.688347]   [<c013e274>] tick_periodic+0x24/0x80
> > [17854.688347]   [<c013e2e2>] tick_handle_periodic+0x12/0x70
> > [17854.688347]   [<c0104e24>] timer_interrupt+0x14/0x20
> > [17854.688347]   [<c01607b9>] handle_IRQ_event+0x29/0x60
> > [17854.688347]   [<c0161c59>] handle_level_irq+0x69/0xe0
> > [17854.688347]   [<ffffffff>] 0xffffffff
> > [17854.688347] irq event stamp: 55771
> > [17854.688347] hardirqs last  enabled at (55771): [<c0309125>]
> > _spin_unlock_irqrestore+0x35/0x60 [17854.688347] hardirqs last
> > disabled at (55770): [<c0309419>] _spin_lock_irqsave+0x19/0x80
> > [17854.688347] softirqs last  enabled at (54836): [<c0124f54>]
> > __do_softirq+0xc4/0x110 [17854.688347] softirqs last disabled at
> > (54831): [<c01049ae>] do_softirq+0x8e/0xe0 [17854.688347]
> > [17854.688347] other info that might help us debug this:
> > [17854.688347] 3 locks held by pm-suspend/18240:
> > [17854.688347]  #0:  (&buffer->mutex){--..}, at: [<c01dd4c5>]
> > sysfs_write_file+0x25/0x100 [17854.688347]  #1:  (pm_mutex){--..},
> > at: [<c015056f>] enter_state+0x4f/0x140 [17854.688347]  #2:=20
> > (dpm_list_mtx){--..}, at: [<c027880f>] device_pm_lock+0xf/0x20
> > [17854.688347]
> > [17854.688347] stack backtrace:
> > [17854.688347] Pid: 18240, comm: pm-suspend Not tainted
> > 2.6.29-rc2-1avb #1 [17854.688347] Call Trace:
> > [17854.688347]  [<c0306248>] ? printk+0x18/0x20
> > [17854.688347]  [<c0141fac>] print_usage_bug+0x16c/0x1d0
> > [17854.688347]  [<c0142bcf>] mark_lock+0x8bf/0xc90
> > [17854.688347]  [<c0106b8f>] ? pit_next_event+0x2f/0x40
> > [17854.688347]  [<c01441b0>] __lock_acquire+0x580/0x1930
> > [17854.688347]  [<c030916d>] ? _spin_unlock+0x1d/0x20
> > [17854.688347]  [<c0106b8f>] ? pit_next_event+0x2f/0x40
> > [17854.688347]  [<c013dd38>] ? clockevents_program_event+0x98/0x160
> > [17854.688347]  [<c0142fe8>] ? mark_held_locks+0x48/0x90
> > [17854.688347]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
> > [17854.688347]  [<c0143229>] ? trace_hardirqs_on_caller+0x139/0x190
> > [17854.688347]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
> > [17854.688347]  [<c01455bc>] lock_acquire+0x5c/0x80
> > [17854.688347]  [<c0136fcc>] ? retrigger_next_event+0x5c/0xa0
> > [17854.688347]  [<c03092e5>] _spin_lock+0x35/0x70
> > [17854.688347]  [<c0136fcc>] ? retrigger_next_event+0x5c/0xa0
> > [17854.688347]  [<c0136fcc>] retrigger_next_event+0x5c/0xa0
> > [17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
> > [17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
> > [17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
> > [17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
> > [17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
> > [17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
> > [17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
> > [17854.688347]  [<c0150614>] enter_state+0xf4/0x140
> > [17854.688347]  [<c01506dd>] state_store+0x7d/0xc0
> > [17854.688347]  [<c0150660>] ? state_store+0x0/0xc0
> > [17854.688347]  [<c0202da4>] kobj_attr_store+0x24/0x30
> > [17854.688347]  [<c01dd53c>] sysfs_write_file+0x9c/0x100
> > [17854.688347]  [<c019916c>] vfs_write+0x9c/0x160
> > [17854.688347]  [<c0103494>] ? restore_nocheck_notrace+0x0/0xe
> > [17854.688347]  [<c01dd4a0>] ? sysfs_write_file+0x0/0x100
> > [17854.688347]  [<c01992ed>] sys_write+0x3d/0x70
> > [17854.688347]  [<c0103371>] sysenter_do_call+0x12/0x31
>
> Not sure what caused this to trigger, but it looks like
> timekeeping_resume() isn't called with IRQs disabled (and the code
> doesn't seem to expect that since it uses write_seqlock_irqsave).
>
> hres_timers_resume() however calls retrigger_next_event() which does
> require IRQs disabled and doesn't do that.
>
> Like said, I'm not sure what caused this since the code in question
> doesn't seem to have changed since April 2007.
>
> Anyway, does the below patch cure trouble?

Hard to say because I do not know how to reliably trigger the BUG in the=20
first place. I'll keep watch with the patch applied. Thanks!

> ---
> Subject: hrtimer: fix irq recursion deadlock
>
> retrigger_next_event() requires IRQs disabled, provide that for the
> resume callback.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 2c40ee8..430103d 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -614,8 +614,12 @@ void clock_was_set(void)
>   */
>  void hres_timers_resume(void)
>  {
> +	unsigned long flags;
> +
>  	/* Retrigger the CPU local events: */
> +	local_irq_save(flags);
>  	retrigger_next_event(NULL);
> +	local_irq_restore(flags);
>  }
>
>  /*


--nextPart2028459.CyzrO676g1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklzV48ACgkQR6LMutpd94ymoACgsYXPvxlRbEqtym+O+wJqp3X+
FzcAoIfMlprbP54SSrdyZWNTLVXzt1Id
=HKhB
-----END PGP SIGNATURE-----

--nextPart2028459.CyzrO676g1--
