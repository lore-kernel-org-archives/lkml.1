Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZERN7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZERN7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZERN7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:59:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:42127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZERN7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:59:06 -0400
Date: Mon, 18 May 2009 06:58:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: tom.leiming@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] kernel:async function call:introduce
 async_run_inatomic(v3)
Message-ID: <20090518065858.387b7012@infradead.org>
In-Reply-To: <20090518131054.1ace6885@gondolin>
References: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
	<20090518131054.1ace6885@gondolin>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 13:10:54 +0200
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Sat, 16 May 2009 21:54:17 +0800,
> tom.leiming@gmail.com wrote:
> 
> > + /**
> > + * async_run_inatomic - in atomic contexts schedule a function for
> > + * 			asynchronous execution
> > + *
> > + * @ptr: function to execute asynchronously
> > + * @data: data pointer to pass to the function
> > + *
> > + * The purpose of this function is to offer a simple way to
> > schedule an
> > + * asynchronous thread from an atomic context.
> > + *
> > + * Return zero one success, !zero on failured
> > + * Note: async_run_inatomic() uses a distinct running list in order
> > + * to avoid slowing down synchronization within the general domain.
> > + * Since it does not return a cookie for checkpointing, it is for
> > callers
> > + * that don't need later synchronization.
> > + */
> > +int async_run_inatomic(async_func_ptr *ptr, void *data)
> > +{
> > +	return !__async_schedule(ptr, data,
> > &async_running_no_sync, 1); +}
> > +EXPORT_SYMBOL_GPL(async_run_inatomic);
> > +
> 
> While we can skip synchronization on cookies, we still need something
> like async_run_synchronize() for module unloading (and possibly
> others).

We don't have this problem if we use the existing naming and existing
standard domain... 
(I don't like the "run" part of the name, rather than schedule.. lets
keep the apis consistent please)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
