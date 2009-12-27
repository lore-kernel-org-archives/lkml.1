Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbZL0EC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbZL0EC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 23:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbZL0EC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 23:02:57 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49543 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZL0EC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 23:02:57 -0500
To: serge@hallyn.com
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091225055034.GA374@us.ibm.com>
	<20091226195043.GA1945@heat>
	<20091227031631.GA17629@hallyn.com>
In-Reply-To: <20091227031631.GA17629@hallyn.com>
Message-Id: <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 27 Dec 2009 13:02:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Well, according to Mimi's email this is essentially what was
> decided upon for IMA.  So I think workable guidelines would
> be that anything which can't possibly be expected to interfere
> with other LSMs can be added like that.
>
> More generally, the flaw in the approach is that the hooks for
> several permutations of LSMs might interfere with each other.
> So for instance the cap_inode_setxattr() hook should always
> be called if selinux is not enabled, but should not be called
> for security.selinux namespace xattrs if selinux is enabled.

May I do opportunistic question regarding TOMOYO?

I'm distributing SELinux+TOMOYO kernels (since Fedora Core 3) and
AppArmor+TOMOYO kernels (since openSuSE 10.1), but I didn't encounter problems.
TOMOYO can use similar approach which disablenetwork uses (i.e. adding
dedicated variable to task_struct and not using "void *security" and not using
LSM hooks for allocating/freeing "void *security" and not using xattr of
filesystems).

@@ -1557,6 +1559,10 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_CCSECURITY
+	struct ccs_domain_info *ccs_domain_info;
+	u32 ccs_flags;
+#endif
 };

I believe TOMOYO can safely coexist with other security modules.
Why TOMOYO must not be used with SELinux or Smack or AppArmor?
What interference are you worrying when enabling TOMOYO with SELinux or Smack
or AppArmor?

Regards.
