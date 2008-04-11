Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbYDKOMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbYDKOMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbYDKOMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:12:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55775 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760810AbYDKOMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:12:33 -0400
To: matthew@wil.cx
Cc: paul.moore@hp.com, penguin-kernel@I-love.SAKURA.ne.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
	<20080404122408.986477936@I-love.SAKURA.ne.jp>
	<200804071140.59247.paul.moore@hp.com>
	<47FC8052.9070409@nttdata.co.jp>
	<20080409131151.GK11962@parisc-linux.org>
In-Reply-To: <20080409131151.GK11962@parisc-linux.org>
Message-Id: <200804112312.HGE69734.LFOOHQOSFFMJtV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 11 Apr 2008 23:12:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for slow response.

Matthew Wilcox wrote:
> When the rule is put in place, say "No modifications to /etc/passwd",
> look up the inode and major:minor of /etc/passwd.  If there's a rename,
> look up the new inode number.  If it's mounted elsewhere, it doesn't
> matter, they still can't modify it because it has the same
> major:minor:inode.

If write access is denied because of a rule "No modifications to /etc/passwd",
a rule "Allow modifications to /tmp/passwd" can no longer be enforced after
"mount --bind /etc/ /tmp/" or "mount --bind /etc/passwd /tmp/passwd" or
"mv /etc/passwd /tmp/passwd" or "ln /etc/passwd /tmp/passwd" is done.

"No modifications" (i.e. "forbid modifications") and
"Allow modifications" (i.e. "don't forbid modifications") are incompatible
rules as long as the rules are described using pathnames but the judgment is
done using inodes (or labels).

If rules are described like "No modifications to passwd_t",
it is correct to deny modifications of the file when the file
with passwd_t was renamed or bind-mounted or hard-linked.
Those who want to do access restriction based on the entity of the file
prefer rules described using inodes (or labels).

If rules are described like "No modifications to /etc/passwd" and
"Allow modifications to /tmp/passwd", it is wrong to deny modifications of
the file when /etc/passwd was renamed or bind-mounted or hard-linked to
/tmp/passwd .
Those who want to do access restriction based on the location of the file
prefer rules described using pathnames.

SELinux and Smack are the former.
AppArmor and TOMOYO Linux are the latter.

> Is this workable?
I'm afraid it is unlikely.

Thank you.
