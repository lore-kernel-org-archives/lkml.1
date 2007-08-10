Return-Path: <linux-kernel-owner+w=401wt.eu-S934641AbXHJJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbXHJJ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbXHJJ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:56:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:5763 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995AbXHJJ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:56:13 -0400
Date: Fri, 10 Aug 2007 13:55:54 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: + sysct-mqueue-remove-the-binary-sysctl-numbers.patch added to -mm tree
Message-ID: <20070810095554.GB6726@localhost.sw.ru>
References: <200708100141.l7A1fsdV029562@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708100141.l7A1fsdV029562@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 06:41:54PM -0700, akpm@linux-foundation.org wrote:
> Subject: sysctl mqueue: remove the binary sysctl numbers
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Because of a conflict with FS_INODE_NR none of the binary sysctl numbers use
> by mqueue, were available to user space.  So just remove them.

OK with me. FS_INODE_NR was there first. :)

> --- a/ipc/mqueue.c~sysct-mqueue-remove-the-binary-sysctl-numbers
> +++ a/ipc/mqueue.c
> @@ -44,12 +44,6 @@
>  #define STATE_PENDING	1
>  #define STATE_READY	2
>  
> -/* used by sysctl */
> -#define FS_MQUEUE 	1
> -#define CTL_QUEUESMAX 	2
> -#define CTL_MSGMAX 	3
> -#define CTL_MSGSIZEMAX 	4
> -
>  /* default values */
>  #define DFLT_QUEUESMAX	256	/* max number of message queues */
>  #define DFLT_MSGMAX 	10	/* max number of messages in each queue */
> @@ -1197,7 +1191,6 @@ static int msg_maxsize_limit_max = INT_M
>  
>  static ctl_table mq_sysctls[] = {
>  	{
> -		.ctl_name	= CTL_QUEUESMAX,
>  		.procname	= "queues_max",
>  		.data		= &queues_max,
>  		.maxlen		= sizeof(int),
> @@ -1205,7 +1198,6 @@ static ctl_table mq_sysctls[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  	{
> -		.ctl_name	= CTL_MSGMAX,
>  		.procname	= "msg_max",
>  		.data		= &msg_max,
>  		.maxlen		= sizeof(int),
> @@ -1215,7 +1207,6 @@ static ctl_table mq_sysctls[] = {
>  		.extra2		= &msg_max_limit_max,
>  	},
>  	{
> -		.ctl_name	= CTL_MSGSIZEMAX,
>  		.procname	= "msgsize_max",
>  		.data		= &msgsize_max,
>  		.maxlen		= sizeof(int),
> @@ -1229,7 +1220,6 @@ static ctl_table mq_sysctls[] = {
>  
>  static ctl_table mq_sysctl_dir[] = {
>  	{
> -		.ctl_name	= FS_MQUEUE,
>  		.procname	= "mqueue",
>  		.mode		= 0555,
>  		.child		= mq_sysctls,

