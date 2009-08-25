Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZHYJGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZHYJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZHYJF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:05:59 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4504 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZHYJF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:05:58 -0400
X-Greylist: delayed 944 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 05:05:56 EDT
Date: Tue, 25 Aug 2009 10:50:13 +0200
From: Nicolas George <nicolas.george@normalesup.org>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [cpufreq] Autoloading governors blocks
Message-ID: <20090825085013.GA7577@phare.normalesup.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Tue, 25 Aug 2009 10:50:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

Yesterday, on a freshly-compiled 2.6.30.5 kernel, I noticed that changing to
a governor that exists as a module but is not loaded causes the process that
did the change to go to state D, along with any process later accessing the
cpufreq nodes.

The CPU is a Thurion64, working with powernow-k8. The kernel is configured
with CONFIG_X86_64, CONFIG_PREEMPT, CONFIG_NO_HZ. The governor, at the time
the problem happened, was ondemand.

The problem happened either when loading powersave or userspace. On the
other hand, selecting a governor that is already loaded works fine, and
trying to autoload a governor that does not exist fails normally.

I do not have a lot of time to investigate, I hope this bug report may be
useful.

Regards,

--=20
  Nicolas George

[34560.087058] INFO: task kondemand/0:5412 blocked for more than 120 second=
s.
[34560.087066] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[34560.087073] kondemand/0   D 0000000000000000     0  5412      2
[34560.087084]  ffffffff80586380 0000000000000046 0000000000000001 ffff8800=
3c9fed30
[34560.087094]  ffff88003c9fefd8 ffff88003c9fefd8 ffffffff80596700 ffffffff=
80596f20
[34560.087104]  ffff88003f853a00 ffff88003c9fed30 ffffffff805cbec0 ffffffff=
a02f1b00
[34560.087113] Call Trace:
[34560.087150]  [<ffffffffa02f0590>] ? do_dbs_timer+0x0/0x320 [cpufreq_onde=
mand]
[34560.087162]  [<ffffffff804ad553>] ? schedule+0x13/0x40
[34560.087172]  [<ffffffff804afa35>] ? __down_write_nested+0x85/0xe0
[34560.087186]  [<ffffffff8040dab8>] ? lock_policy_rwsem_write+0x18/0x40
[34560.087199]  [<ffffffffa02f05ff>] ? do_dbs_timer+0x6f/0x320 [cpufreq_ond=
emand]
[34560.087215]  [<ffffffffa02f0590>] ? do_dbs_timer+0x0/0x320 [cpufreq_onde=
mand]
[34560.087226]  [<ffffffff8024a8ac>] ? worker_thread+0x19c/0x2c0
[34560.087234]  [<ffffffff8024eb50>] ? autoremove_wake_function+0x0/0x30
[34560.087243]  [<ffffffff8024a710>] ? worker_thread+0x0/0x2c0
[34560.087251]  [<ffffffff8024a710>] ? worker_thread+0x0/0x2c0
[34560.087259]  [<ffffffff8024e5ae>] ? kthread+0x4e/0x90
[34560.087267]  [<ffffffff8020cb6a>] ? child_rip+0xa/0x20
[34560.087275]  [<ffffffff8024e560>] ? kthread+0x0/0x90
[34560.087282]  [<ffffffff8020cb60>] ? child_rip+0x0/0x20
[34560.087310] INFO: task cpufreq-set:25132 blocked for more than 120 secon=
ds.
[34560.087315] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[34560.087320] cpufreq-set   D 0000000000000000     0 25132      1
[34560.087329]  ffff880030d8c110 0000000000000082 0000000000000092 ffff8800=
3d014d70
[34560.087338]  ffff88003d015018 ffff88003d015018 ffff88003e467e48 7fffffff=
ffffffff
[34560.087348]  ffff88003e467bb8 7fffffffffffffff 7fffffffffffffff 00000000=
00000000
[34560.087357] Call Trace:
[34560.087367]  [<ffffffff804ad553>] ? schedule+0x13/0x40
[34560.087376]  [<ffffffff804adbd5>] ? schedule_timeout+0x175/0x1c0
[34560.087385]  [<ffffffff80249d6d>] ? call_usermodehelper_exec+0x8d/0xd0
[34560.087394]  [<ffffffff804ad95a>] ? wait_for_common+0x15a/0x1a0
[34560.087404]  [<ffffffff80230190>] ? default_wake_function+0x0/0x10
[34560.087413]  [<ffffffff80232884>] ? __wake_up+0x54/0xb0
[34560.087425]  [<ffffffff8024adca>] ? __cancel_work_timer+0x16a/0x1d0
[34560.087434]  [<ffffffff8024a520>] ? wq_barrier_func+0x0/0x10
[34560.087448]  [<ffffffffa02f0951>] ? cpufreq_governor_dbs+0xa1/0x2bc [cpu=
freq_ondemand]
[34560.087458]  [<ffffffff8040c8c9>] ? __cpufreq_governor+0xc9/0x130
[34560.087468]  [<ffffffff8040ca52>] ? __cpufreq_set_policy+0x122/0x180
[34560.087477]  [<ffffffff8040d6ef>] ? store_scaling_governor+0xff/0x280
[34560.087486]  [<ffffffff8040e1a0>] ? handle_update+0x0/0x10
[34560.087498]  [<ffffffff8040e07b>] ? store+0x6b/0xa0
[34560.087507]  [<ffffffff80302f3e>] ? sysfs_write_file+0xce/0x160
[34560.087517]  [<ffffffff802ac9b9>] ? vfs_write+0xc9/0x170
[34560.087526]  [<ffffffff802acb63>] ? sys_write+0x53/0xa0
[34560.087534]  [<ffffffff8020bd68>] ? system_call_fastpath+0x16/0x1b

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqTpcUACgkQsGPZlzblTJO1zQCff00WLqJT7pp+DDc3n1vDZkGK
hksAnjO9RpRHnY2g/Q6d4R3RUqwQIdc2
=Lmdj
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
