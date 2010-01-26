Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339Ab0AZGYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0AZGYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968Ab0AZGYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:24:32 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:40316 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0AZGYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bQb5sMcCgvSJrtq3Zqs2oPqu80kOBBk1F9JC5M9zypwIiMmffm5ybVQuHR8/xsQFqu
         ROGH9Sc67WSAbbeWO/N8JdSB9c48DZVrGiSktqMI0Ge7PQkhfHkFsj9kG4GB4Oqcgalk
         JngvIYFv/GIbphgmzrrjjcuhtDyNTQK2S9sVc=
MIME-Version: 1.0
In-Reply-To: <20100126060705.GF19799@ZenIV.linux.org.uk>
References: <2375c9f91001252125w6f5bd3d3he183c61e9dcedd3e@mail.gmail.com>
	 <20100126142644.5AB0.A69D9226@jp.fujitsu.com>
	 <20100126144641.5AB3.A69D9226@jp.fujitsu.com>
	 <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com>
	 <20100126060705.GF19799@ZenIV.linux.org.uk>
Date: Tue, 26 Jan 2010 14:24:30 +0800
Message-ID: <2375c9f91001252224g6712cbady339dbe486a5112ac@mail.gmail.com>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 2:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jan 26, 2010 at 02:01:12PM +0800, Am??rico Wang wrote:
>
>> I agree, it seems that patch is useless, since we already
>> do lock_kernel() before calling __f_setown()...
>
> What's to prevent pid from being freed under us?  BKL won't...
>

Hmm, I don't fully understand the race here. If it is used to protect
'pid' which we get from 'tty->pgrp' or 'current', in the former case,
it is protected by 'tty->ctrl_lock', in the later case, it doesn't need
the lock. So it's not necessary to protect 'pid' by 'tty->crtl_lock'.

Am i missing something?
