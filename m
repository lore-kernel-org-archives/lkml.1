Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbZBXWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbZBXWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760474AbZBXWcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:32:11 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43367 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334AbZBXWcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:32:10 -0500
Date: Tue, 24 Feb 2009 16:32:07 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adobriyan@gmail.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
Message-ID: <20090224223207.GA31959@us.ibm.com>
References: <20090224220256.GA31001@us.ibm.com> <20090224141651.70155ebd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224141651.70155ebd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 24 Feb 2009 16:02:56 -0600
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > +#ifdef CONFIG_PROC_SYSCTL
> > +static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
> > +	void __user *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +	struct ctl_table mq_table;
> > +	memcpy(&mq_table, table, sizeof(mq_table));
> > +	mq_table.data = get_mq(table);
> > +
> > +	return proc_dointvec(&mq_table, write, filp, buffer, lenp, ppos);
> > +}
> > +
> > +static int proc_mq_dointvec_minmax(ctl_table *table, int write,
> > +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +	struct ctl_table mq_table;
> > +	memcpy(&mq_table, table, sizeof(mq_table));
> > +	mq_table.data = get_mq(table);
> > +
> > +	return proc_dointvec_minmax(&mq_table, write, filp, buffer,
> > +					lenp, ppos);
> > +}
> > +#else
> > +proc_handler *proc_mq_dointvec = NULL;
> > +proc_handler *proc_mq_dointvec_minmax = NULL;
> > +#endif
> 
> looks odd.  Was this
> 
> --- a/ipc/mq_sysctl.c~mqueue-namespace-adapt-sysctl-update-fix
> +++ a/ipc/mq_sysctl.c
> @@ -52,8 +52,8 @@ static int proc_mq_dointvec_minmax(ctl_t
>  					lenp, ppos);
>  }
>  #else
> -proc_handler *proc_mq_dointvec = NULL;
> -proc_handler *proc_mq_dointvec_minmax = NULL;
> +#define proc_mq_dointvec NULL
> +#define proc_mq_dointvec_minmax NULL
>  #endif
> 
>  static int msg_max_limit_min = MIN_MSGMAX;
> _
> 
> intended?

It just seemed more in line with the idea of ensuring type
safety...  Of course the #defines will work and are how the
others (at least ipc and utsname) do it, but this seemed
a touch better.  Of course I'll change it if that's the
preference.

thanks,
-serge
