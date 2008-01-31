Return-Path: <linux-kernel-owner+w=401wt.eu-S1765563AbYAaLdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765563AbYAaLdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbYAaLcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:32:54 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56760 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbYAaLcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:32:53 -0500
Message-ID: <47A1B16B.4070404@bull.net>
Date: Thu, 31 Jan 2008 12:30:51 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 05/15] IPC/semaphores: remove one unused
 parameter from semctl_down()
References: <20080129160229.612172683@bull.net> <20080129161758.154775218@bull.net> <47A187AE.1000809@bull.net> <47A1A076.4060108@bull.net>
In-Reply-To: <47A1A076.4060108@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/01/2008 12:40:58,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/01/2008 12:41:00,
	Serialize complete at 31/01/2008 12:41:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Peiffer wrote:
> 
> Nadia Derbey wrote:
> 
>>pierre.peiffer@bull.net wrote:
>>
>>>From: Pierre Peiffer <pierre.peiffer@bull.net>
>>>
>>>semctl_down() takes one unused parameter: semnum.
>>>This patch proposes to get rid of it.
>>>
>>>Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
>>>Acked-by: Serge Hallyn <serue@us.ibm.com>
>>>---
>>> ipc/sem.c |    6 +++---
>>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>>Index: b/ipc/sem.c
>>>===================================================================
>>>--- a/ipc/sem.c
>>>+++ b/ipc/sem.c
>>>@@ -882,8 +882,8 @@ static inline unsigned long copy_semid_f
>>>  * to be held in write mode.
>>>  * NOTE: no locks must be held, the rw_mutex is taken inside this
>>>function.
>>>  */
>>>-static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
>>>-        int cmd, int version, union semun arg)
>>>+static int semctl_down(struct ipc_namespace *ns, int semid,
>>>+               int cmd, int version, union semun arg)
>>> {
>>>     struct sem_array *sma;
>>>     int err;
>>>@@ -974,7 +974,7 @@ asmlinkage long sys_semctl (int semid, i
>>>         return err;
>>>     case IPC_RMID:
>>>     case IPC_SET:
>>>-        err = semctl_down(ns,semid,semnum,cmd,version,arg);
>>>+        err = semctl_down(ns, semid, cmd, version, arg);
>>>         return err;
>>>     default:
>>>         return -EINVAL;
>>>
>>
>>Looks like semnum is only used in semctl_main(). Why not removing it
>>from semctl_nolock() too?
> 
> 
> Indeed.
> In fact, I already fixed that in a previous patch, included in -mm since kernel
> 2.6.24.rc3-mm2 (patch named ipc-semaphores-consolidate-sem_stat-and.patch)
> 

Oops.. Sorry for the "noise"!
