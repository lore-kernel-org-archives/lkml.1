Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYLAUPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYLAUPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYLAUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:15:31 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:42994 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLAUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:15:30 -0500
Subject: Re: [TOMOYO #13 (mmotm 2008-11-19-02-19) 09/11] LSM adapter
	functions.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
In-Reply-To: <20081120112735.226630772@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
	 <20081120112735.226630772@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 01 Dec 2008 15:10:57 -0500
Message-Id: <1228162257.18720.220.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 20:25 +0900, Tetsuo Handa wrote:
> plain text document attachment (tomoyo-hooks.patch)
> This is LSM adapter for TOMOYO.
> This version of TOMOYO assigns only one variable "struct tomoyo_domain_info *"
> to "current->cred->security".
> 
> Future version will require two variables "struct tomoyo_domain_info *" and
> "u32".
> http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/include/linux/sched.h#L1311
> Well, how to implement this while "current->cred->security" cannot be modified
> freely?
> 
> To be honest, the only object which TOMOYO needs to assign variables is
> "struct task_struct". TOMOYO's "T" means "task".
> TOMOYO utilizes characteristics of "struct task_struct".
> For TOMOYO, use of per task variables is vital.
> 
> Removal of security_task_alloc() and security_task_free() by introduction of
> COW credentials will become a nightmare when TOMOYO tries to add "u32".
> Of cource, if TOMOYO is allowed to add "u32" to "struct task_struct",
> COW credentials won't become a nightmare.

Can you explain exactly how you are using this per-task state and why it
is a problem to create a new cred in the situations where you need to
modify it?  I think that this issue needs to be addressed up front.

-- 
Stephen Smalley
National Security Agency

