Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYJIE3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYJIE3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYJIE3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:29:19 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:44342 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYJIE3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:29:18 -0400
Message-Id: <20081009042814.398846861@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 09 Oct 2008 13:28:14 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [TOMOYO #10 (linux-next) 0/8] TOMOYO Linux
X-OriginalArrivalTime: 09 Oct 2008 04:29:13.0398 (UTC) FILETIME=[95212D60:01C929C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is a pathname-based MAC extension (LSM module) for the 
Linux kernel.

Since the latest mmotm (2008-10-02-16-17) lacks CRED patchset by 
David Howells, we used linux-next (-next-20080919) which includes 
CRED patchset.

Diffrences from previous version are as follows.

*about LSM interfaces:
 -added a new LSM hook security_path_clear() for clearing hash 
  table after VFS helper functions. It is needed to perform DAC 
  before MAC.
 -added a new config option CONFIG_SECURITY_PATH for new LSM hooks.

*about task_struct:
 -added in_execve flag to allow LSM modules to determine whether 
  current process is in an execve operation or not so that they can 
  behave differently while an execve operation is in progress.

*about TOMOYO body:
 -made security_inode_*() return result of security_path_*() and 
  removed code clone of DAC.
 -modified to check permisson of interpreter using 
  bprm->cred->security and current->in_execve flag.
 -modified to use get_task_cred() for reading objective LSM context 
  of a task.
 -modified to use bprm->cred->security to know the first call of 
  security_bprm_check() .
 -modified to pass current->cred->security or bprm->cred->security as 
  parameter.

Thanks to Serge for sugguesting DAC-before-MAC workaround.
Thanks to David for patiently reviewing in_execve patch.

Stephen, James, Chris, please review and respond (hopefully Ack).

Regards,
--

