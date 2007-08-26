Return-Path: <linux-kernel-owner+w=401wt.eu-S934902AbXHZCfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbXHZCfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 22:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934050AbXHZCey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 22:34:54 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61912 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbXHZCex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 22:34:53 -0400
X-Greylist: delayed 1261 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 22:34:53 EDT
To: pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 14/15] Conditional permission support.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com>
	<46CED5C6.8050501@gmail.com>
	<20070825110825.GB5850@ucw.cz>
In-Reply-To: <20070825110825.GB5850@ucw.cz>
Message-Id: <200708261113.JHH03043.VQOtSOJLFFFHMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sun, 26 Aug 2007 11:13:48 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Pavel Machek wrote:
> What is that? Language parser in kernel?

Yes. This is a policy parser in kernel.

TOMOYO Linux' policy is passed from/to the kernel as a plain text
(i.e. ASCII printable) file via /proc/tomoyo interface.

For example, to add a permission to allow /usr/sbin/sshd
to execute /bin/bash if the authenticated user's uid = 500,
the administrator runs

# /bin/cat > /proc/tomoyo/domain_policy << EOF
select <kernel> /usr/sbin/sshd
1 /bin/bash if task.uid=500
EOF

and to remove this permission, the administrator runs

# /bin/cat > /proc/tomoyo/domain_policy << EOF
select <kernel> /usr/sbin/sshd
delete 1 /bin/bash if task.uid=500
EOF

The patch [TOMOYO 14/15] handles "if task.uid=500" part.

No compilation at userspace and
only difference between old and new policy is written.
This is similar to LDAP manipulation using LDIF format.

(To be exact, only programs that are registered in
/proc/tomoyo/manager can modify policy via /proc/tomoyo interface.
You need to use /usr/lib/ccs/loadpolicy or something
instead of /bin/cat .)
