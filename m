Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbXJ0OJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbXJ0OJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXJ0OIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:08:51 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58653 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXJ0OIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:08:50 -0400
To: simon@fire.lp0.eu
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071022210956.31f7bbcf@laptopd505.fenrus.org>
	<20071023051642.GA3908@sequoia.sous-sol.org>
	<471E9260.6000704@goop.org>
	<20071023220649.5a76af82@laptopd505.fenrus.org>
	<55615.simon.1193226629@5ec7c279.invalid>
In-Reply-To: <55615.simon.1193226629@5ec7c279.invalid>
Message-Id: <200710272308.GCH56742.OHLVMSFFFQJOtO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 27 Oct 2007 23:08:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Simon Arlott wrote:
> I currently have an LSM that only handles permissions for socket_bind
> and socket_listen, I load it and then "capability" as secondary on
> boot - but now I can't because the LSM framework is now just the LS
> framework.

I think there are two other problems regarding LSM.

(1) There is only one "struct security_ops" structure in the system.

(2) There is only one "void *security" field in "struct task_struct".


Years ago, there was only one MAC implementation (i.e. SELinux)
in the mainline kernel.
But now, there are many MAC (or access control/tracking) implementations
waiting for inclusion into the mainline kernel.
The competition for occupying "struct security_ops" has started.

My idea is that, why not create chains of "struct security_ops"
(i.e. linked list of "struct security_ops")
and allow choosing which chain to use for per a "struct task_struct" basis
(i.e. add "struct security_ops" to "struct task_struct").

TOMOYO Linux is having difficulty that TOMOYO Linux unlikely be able to use
"struct security_ops" since SELinux is occupying it.
Yes, there is secondary_ops in SELinux, but it doesn't help TOMOYO Linux
since SELinux is not calling secondary ops for operations TOMOYO Linux wants to control.
So, there is only one "struct security_ops" as a matter of practice.


At the same time, the competition for occupying "void *security" has started.

My idea is that, why not allow multiple "void *security" fields in "struct task_struct"?

TOMOYO Linux is having difficulty that TOMOYO Linux unlikely be able to use
"struct task_struct"->security field since SELinux is occupying it.
If TOMOYO Linux is permitted to add "void *" and "u32" to "struct task_struct",
SELinux and other LSM implementations can use "struct task_struct"->security field.


May be we should consider stackable LSM again?

Regards.

