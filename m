Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbZBXWRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbZBXWRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbZBXWRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:17:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbZBXWRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:17:40 -0500
Date: Tue, 24 Feb 2009 14:16:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: adobriyan@gmail.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
Message-Id: <20090224141651.70155ebd.akpm@linux-foundation.org>
In-Reply-To: <20090224220256.GA31001@us.ibm.com>
References: <20090224220256.GA31001@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 16:02:56 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> +#ifdef CONFIG_PROC_SYSCTL
> +static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
> +	void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table mq_table;
> +	memcpy(&mq_table, table, sizeof(mq_table));
> +	mq_table.data = get_mq(table);
> +
> +	return proc_dointvec(&mq_table, write, filp, buffer, lenp, ppos);
> +}
> +
> +static int proc_mq_dointvec_minmax(ctl_table *table, int write,
> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table mq_table;
> +	memcpy(&mq_table, table, sizeof(mq_table));
> +	mq_table.data = get_mq(table);
> +
> +	return proc_dointvec_minmax(&mq_table, write, filp, buffer,
> +					lenp, ppos);
> +}
> +#else
> +proc_handler *proc_mq_dointvec = NULL;
> +proc_handler *proc_mq_dointvec_minmax = NULL;
> +#endif

looks odd.  Was this

--- a/ipc/mq_sysctl.c~mqueue-namespace-adapt-sysctl-update-fix
+++ a/ipc/mq_sysctl.c
@@ -52,8 +52,8 @@ static int proc_mq_dointvec_minmax(ctl_t
 					lenp, ppos);
 }
 #else
-proc_handler *proc_mq_dointvec = NULL;
-proc_handler *proc_mq_dointvec_minmax = NULL;
+#define proc_mq_dointvec NULL
+#define proc_mq_dointvec_minmax NULL
 #endif
 
 static int msg_max_limit_min = MIN_MSGMAX;
_

intended?
