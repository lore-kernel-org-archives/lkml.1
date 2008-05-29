Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYE2NLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYE2NLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYE2NLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:11:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:22609 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYE2NLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=F4DpUd2QXjfDnhArTlrOh0WZ5iBmNpMTCC+hdBPZh+IG6KOlMziyhBG2sWBbM9ACfwxqJx8XV6O9giZgGK9vkKDAuRk/pEkcnseiSYYi/wtf507y3vpmzyRYCcGBALY1cfUEEJrJxJnaJsPUpVVsBNC8icD3O9c5kC7NaOwftEg=
Date: Thu, 29 May 2008 10:14:32 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] on_each_cpu(): kill unused 'retry' parameter
Message-ID: <20080529131432.GA25627@Pilar.ictp.trieste.it>
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com> <1212051661-12733-3-git-send-email-jens.axboe@oracle.com> <20080529125151.GA25124@Pilar.ictp.trieste.it> <20080529125429.GE25504@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529125429.GE25504@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29.May'08 at 14:54:29 +0200, Jens Axboe wrote:
> On Thu, May 29 2008, Carlos R. Mafra wrote:
> > Hi,
> > 
> > Just a naive comment/question:
> > 
> > > -	if (on_each_cpu(ipi_imb, NULL, 1, 1))
> > > +	if (on_each_cpu(ipi_imb, NULL, 1))
> > 
> > A few weeks ago I though about removing the second argument
> > from on_each_cpu, which is NULL more or less 70% of the time.
> > 
> > Do you think it is possible?
> > Have you already thought about it? 
> 
> It's the data argument to the function, I highly doubt you can get
> rid of that I'm afraid. on_each_cpu() is just a thin wrapper on
> top of smp_call_function() so that the caller doesn't have to
> care about manually calling on the local CPU. So as long as
> smp_call_function() has a data argument, on_each_cpu() should
> carry it as well.
> 
> So nope, I don't think that's feasible (or even desired).

Ok, thanks for the reply!
