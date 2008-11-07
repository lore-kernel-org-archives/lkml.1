Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYKGQF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYKGQF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKGQFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:05:19 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53436 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYKGQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:05:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081107044118.GA21330@x200.localdomain>
Date: Fri, 07 Nov 2008 08:04:40 -0800
In-Reply-To: <20081107044118.GA21330@x200.localdomain> (Alexey Dobriyan's
	message of "Fri, 7 Nov 2008 07:41:18 +0300")
Message-ID: <m18wrvv7xj.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] proc: Supply proc_shrink_automounts when CONFIG_PROC_FS=N
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexey Dobriyan <adobriyan@gmail.com> writes:

>>  	tracehook_prepare_release_task(p);
>>  	atomic_dec(&p->user->processes);
>> +	proc_shrink_automounts();
>
> This, of course, won't compile when PROC_FS=n.

Which of course leads to this incremental patch.

Oops.  I forgot to account for the rare but possible
case of someone not compiling procfs into their kernel.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/proc_fs.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 52cc6bd..394593d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -207,6 +207,9 @@ static inline void proc_net_remove(struct net *net, const char *name) {}
 static inline void proc_flush_task(struct task_struct *task)
 {
 }
+static inline void proc_shrink_automounts(void)
+{
+}
 
 static inline struct proc_dir_entry *create_proc_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
-- 
1.5.3.rc6.17.g1911
