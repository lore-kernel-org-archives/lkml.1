Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbZCWW0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbZCWW0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZCWW03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:26:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38595 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZCWW02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:26:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 07/12] DRBD: main
Date: Mon, 23 Mar 2009 23:26:31 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27-9-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-8-git-send-email-philipp.reisner@linbit.com> <20090323165126.GA2649@x200.localdomain>
In-Reply-To: <20090323165126.GA2649@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903232326.31962.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 März 2009 17:51:26 schrieb Alexey Dobriyan:
> On Mon, Mar 23, 2009 at 04:48:02PM +0100, Philipp Reisner wrote:
> > +#if CONFIG_PROC_FS
> > +	/*
> > +	 * register with procfs
> > +	 */
> > +	drbd_proc = create_proc_entry("drbd",  S_IFREG | S_IRUGO , NULL);
> > +
> > +	if (!drbd_proc)	{
> > +		printk(KERN_ERR "drbd: unable to register proc file\n");
> > +		goto Enomem;
> > +	}
> > +
> > +	drbd_proc->proc_fops = &drbd_proc_fops;
>
> Use proc_create().
>
> > +	drbd_proc->owner = THIS_MODULE;
>
> Unnecessary now.
>
> > +#else
> > +# error "Currently drbd depends on the proc file system
> > (CONFIG_PROC_FS)" +#endif
>
> You should "depends on PROC_FS" then and remove this #error.
> #ifdef would also become unnecessary.

Thanks!
I have updated my code and the patches.
http://oss.linbit.com/drbd/mainline_submission/03-23/

I will repost in a few days, after potentially more reviews

