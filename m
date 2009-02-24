Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZBXIZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZBXIZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZBXIZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:25:39 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:42858 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZBXIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:25:38 -0500
Message-ID: <49A3AEFD.3050705@fr.ibm.com>
Date: Tue, 24 Feb 2009 09:25:33 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
References: <20090224030347.GA10913@us.ibm.com>	<20090224030933.GC11441@us.ibm.com> <20090224043512.GA3202@x200.localdomain>
In-Reply-To: <20090224043512.GA3202@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Feb 23, 2009 at 09:09:33PM -0600, Serge E. Hallyn wrote:
>> +#ifdef CONFIG_PROC_FS
>> +static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
>> +	void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	struct ctl_table mq_table;
>> +	memcpy(&mq_table, table, sizeof(mq_table));
>> +	mq_table.data = get_mq(table);
>> +
>> +	return proc_dointvec(&mq_table, write, filp, buffer, lenp, ppos);
>> +}
>> +
>> +static int proc_mq_dointvec_minmax(ctl_table *table, int write,
>> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	struct ctl_table mq_table;
>> +	memcpy(&mq_table, table, sizeof(mq_table));
>> +	mq_table.data = get_mq(table);
>> +
>> +	return proc_dointvec_minmax(&mq_table, write, filp, buffer,
>> +					lenp, ppos);
>> +}
>> +#else /* CONFIG_PROC_FS */
>> +static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
>> +	void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	return -ENOSYS;
>> +}
>> +
>> +static int proc_mq_dointvec_minmax(ctl_table *table, int write,
>> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	return -ENOSYS;
>> +}
>> +#endif /* CONFIG_PROC_FS */
> 
> These should be under CONFIG_PROC_SYSCTL and one should define them to
> NULL otherwise.

ipc_sysctl.c and utsname_sysctl.c need to fix the CONFIG_PROC_FS #ifdef.

C.
