Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbXH2FZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbXH2FZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXH2FZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:25:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48233 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXH2FZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:25:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828214956.5f3020ef.akpm@linux-foundation.org>
Date: Tue, 28 Aug 2007 23:24:55 -0600
In-Reply-To: <20070828214956.5f3020ef.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 28 Aug 2007 21:49:56 -0700")
Message-ID: <m18x7uc3q0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 28 Aug 2007 16:40:15 -0600 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
>> +static int deprecated_sysctl_warning(struct __sysctl_args *args)
>> +{
>> +	static int msg_count;
>> +	int name[CTL_MAXNAME];
>> +	int i;
>> +
>> +	/* Read in the sysctl name for better debug message logging */
>> +	for (i = 0; i < args->nlen; i++)
>> +		if (get_user(name[i], args->name + i))
>> +			return -EFAULT;
>> +
>> +	/* Ignore accesses to kernel.version */
>> + if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
>> +		return 0;
>
> Do we want to do all the above if msg_count>=5?

Well.  It won't really change order of the algorithm because we have
to read the data in any way.  So an earlier short circuit exit
would speed things up by a little bit, but it really shouldn't
matter either way.

Eric
