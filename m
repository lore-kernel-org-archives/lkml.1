Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZBXMJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZBXMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZBXMJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:09:49 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52247 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:09:48 -0500
Message-ID: <49A3E384.2050308@fr.ibm.com>
Date: Tue, 24 Feb 2009 13:09:40 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg Kurz <gkurz@fr.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: debugging threaded apps running under a clone(CLONE_NEWPID)
References: <499EE0D1.1010001@fr.ibm.com>  <20090223182153.GD13151@us.ibm.com> <49A3C314.6010806@fr.ibm.com> <1235474932.12827.62.camel@bahia>
In-Reply-To: <1235474932.12827.62.camel@bahia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz wrote:
> On Tue, 2009-02-24 at 10:51 +0100, Cedric Le Goater wrote:
>> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
>> ---
>>  fs/proc/base.c |   19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> Index: 2.6.27-mcr.git/fs/proc/base.c
>> ===================================================================
>> --- 2.6.27-mcr.git.orig/fs/proc/base.c
>> +++ 2.6.27-mcr.git/fs/proc/base.c
>> @@ -2444,6 +2444,23 @@ static int proc_tgid_io_accounting(struc
>>  }
>>  #endif /* CONFIG_TASK_IO_ACCOUNTING */
>>
>> +static int proc_pid_vpids(struct task_struct *task, char *buffer)
>> +{
>> +	struct pid_namespace *pid_ns = task->nsproxy->pid_ns;
>> +
> 
> This breaks if task is a zombie...

Indeed. I'll be careful to fix this case in the next patch if it becomes more 
than a concept.

Thanks,

C. 
