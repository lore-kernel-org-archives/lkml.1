Return-Path: <linux-kernel-owner+w=401wt.eu-S1764329AbYCFPEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764329AbYCFPEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbYCFPEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:04:31 -0500
Received: from namei.org ([69.55.235.186]:39347 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753769AbYCFPEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:04:30 -0500
Date: Fri, 7 Mar 2008 02:03:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH -v8 -rc3] Security: Introduce security= boot parameter
In-Reply-To: <1865922a0803060632kb63405fj3d255472fb2e555f@mail.gmail.com>
Message-ID: <Xine.LNX.4.64.0803070159280.8501@us.intercode.com.au>
References: <20080306121913.GA8506@ubuntu>  <Xine.LNX.4.64.0803070025440.16767@us.intercode.com.au>
 <1865922a0803060632kb63405fj3d255472fb2e555f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Ahmed S. Darwish wrote:

> Would you mind answering my confusions below so I can do the change
> with good understanding ?
> 
> I see preempt_disable() before calling security and vfs_caches init,
> but what will prevent two processors/cores from executing
> security_module_enable() concurrently (thus possibly corrupting
> chosen_lsm) ?
> security_module_enable() is also now used in __init init_smk_fs().
> 
> Or the init path got executed serially ?

The init phase only runs on one cpu, see the lock_kernel() in 
kernel_init(), from which context the initcalls are eventually run in 
sequence.


- James
-- 
James Morris
<jmorris@namei.org>
