Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYAGKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYAGKvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYAGKv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:51:27 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:57028 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752772AbYAGKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:51:26 -0500
Subject: Re: [PATCH 00/11] another rt group sched update
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080106161128.152634000@chello.nl>
References: <20080106161128.152634000@chello.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UI1TLGURxUan3GH4MmWW"
Date: Mon, 07 Jan 2008 11:51:20 +0100
Message-Id: <1199703080.7143.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UI1TLGURxUan3GH4MmWW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The list of open points and issues for this work:

 - review/testing

 - handle the PI case better

   The only thing I can come up with currently is to basically have two
   priority arrays one for boosted and one for non boosted tasks, and
   normally run the highest of either array, but in the case of a
   throttled group, only pick from the boosted array.

   Not sure I like that for its space overhead, Steven?

 - I occasionally see a weird lockup on iterating the task_groups list
   on smp machines. - I failed to see anything wrong, but hey, this
   stack of used brown paper bags is steadily growing.

 - figure out what to do for UID based group scheduling, the current
   implementation leaves it impossible for !root users to execute
   real time tasks by setting rt_runtime_us to 0, and it has no way
   to change it.

   Srivatsa, what happened to the per uid weight patches?, Perhaps we
   can extend that interface to allow changing this.

 - I guess documentation needs to be written ;-)

--=-UI1TLGURxUan3GH4MmWW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHggQoXA2jU0ANEf4RAjevAKCEICt2HWsCAp/YpdAaOnu6IzVAUgCeKpW3
3o3FNZ5axKjmyi8T+ZxGBBI=
=Sebz
-----END PGP SIGNATURE-----

--=-UI1TLGURxUan3GH4MmWW--

