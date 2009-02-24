Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbZBXW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbZBXW0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbZBXW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:26:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43854 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbZBXW0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:26:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dl2A+CIBRTOCwtnX0gw5QEL+wYmfwdzQkexHkDpiN0biV3o4+gAZ7pd43nZ70THyrP
         5B5JeI2cFP4TmyPtc3h0wJypgf0mOHDp9XzA3SXfO4HbHc9TkZ0wJ4qa8IUKT6lx0WzE
         xdQt0m0TgpCraXMKl+IXYRKWZzzz44xHr7qoY=
Date: Wed, 25 Feb 2009 01:32:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
Message-ID: <20090224223245.GA17473@x200.localdomain>
References: <20090224220256.GA31001@us.ibm.com> <20090224141651.70155ebd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224141651.70155ebd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 02:16:51PM -0800, Andrew Morton wrote:
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

I hope, not.

"#define foo NULL" is the least intrusive thing.
