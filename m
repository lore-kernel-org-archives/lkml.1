Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612Ab0AZIqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0AZIqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203Ab0AZIp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:45:58 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:55882 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0AZIp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iHyeHPTs61ffxPq4ig/0QIvhwKN6S+gUUvXUTfOUTO9/Q44Rh4E5Fu5JiZ2mRP0+dD
         1GCXRBK+ilVa1AkZo1rv5KmEce/4phNqQn6zPuQUYeCRM8iSiJrJD+a5ZHpEO3j+ZjMj
         pa+nFtxzzJIsDIxnzwUi354VQJwBY7a23e5FI=
MIME-Version: 1.0
In-Reply-To: <20100126164018.1D59.A69D9226@jp.fujitsu.com>
References: <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com>
	 <20100126060705.GF19799@ZenIV.linux.org.uk>
	 <20100126164018.1D59.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Jan 2010 16:45:57 +0800
Message-ID: <2375c9f91001260045s7d01c427g64bc10f5bf4db4d@mail.gmail.com>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0Q8km54013099

On Tue, Jan 26, 2010 at 3:45 PM, KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:> Hi>>> On Tue, Jan 26, 2010 at 02:01:12PM +0800, Am??rico Wang wrote:>>>> > I agree, it seems that patch is useless, since we already>> > do lock_kernel() before calling __f_setown()...>>>> What's to prevent pid from being freed under us?  BKL won't...>> I don't understand this issue at all. so, this is stupid dumb question.> Why can't we write following code?>>>                enum pid_type type;>                struct pid *pid;>                if (!waitqueue_active(&tty->read_wait))>                        tty->minimum_to_wake = 1;>                spin_lock_irqsave(&tty->ctrl_lock, flags);>                if (tty->pgrp) {>                        pid = tty->pgrp;>                        type = PIDTYPE_PGID;>                } else {>                        pid = task_pid(current);>                        type = PIDTYPE_PID;>                }>                get_pid(pid)                                    // insert here>                spin_unlock_irqrestore(&tty->ctrl_lock, flags);>                retval = __f_setown(filp, pid, type, 0);>                put_pid(pid)                                    // insert here>
Yeah, this seems reasonable for me, but not sure if this is the best fix.���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
