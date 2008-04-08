Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYDHUqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYDHUqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYDHUqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:46:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42819 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755589AbYDHUqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:46:20 -0400
Message-ID: <47FBD99A.2080007@sgi.com>
Date: Tue, 08 Apr 2008 13:46:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>	 <20080408184301.975491000@polaris-admin.engr.sgi.com> <36ca99e90804081240q31516fbegadbcc98360813863@mail.gmail.com>
In-Reply-To: <36ca99e90804081240q31516fbegadbcc98360813863@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>>  --- linux-2.6.x86.sched.orig/drivers/base/node.c
>>  +++ linux-2.6.x86.sched/drivers/base/node.c
>>  @@ -19,22 +19,34 @@ static struct sysdev_class node_class =
>>   };
>>
>>
>>  -static ssize_t node_read_cpumap(struct sys_device * dev, char * buf)
>>  +static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
>>   {
>>         struct node *node_dev = to_node(dev);
>>         node_to_cpumask_ptr(mask, node_dev->sysdev.id);
>>         int len;
>>
>>  -       /* 2004/06/03: buf currently PAGE_SIZE, need > 1 char per 4 bits. */
>>  -       BUILD_BUG_ON(MAX_NUMNODES/4 > PAGE_SIZE/2);
>>  +       /* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
>>  +       BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
> Is this right, that you switch from MAX_NUMNODES to NR_CPUS?
> 
> Regards
> Bert

It's printing the number of cpus on a node, so the number of nodes is not
important, it's how many cpus can fit on the head of a node... ;-)

Thanks,
Mike
