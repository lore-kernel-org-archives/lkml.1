Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYHSVlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYHSVlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbYHSVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:40:33 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:43305 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbYHSVkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=E0nSTMYlveAsiT1TXkxlCuT9M3MJlBbyKJnV/roVQPh4UqIECHSTiw2plEenKr0Hew
         kEuhJv/YwB97S1FKO6XzfBVPulSuTWuYXd30kLzWv1bQOfYHZSGXQA1FpZS9ct/Jc0+z
         ab5EwLKRmki3x1xTnIcK0CnzL6c2bb/Hxnk7I=
Date: Wed, 20 Aug 2008 00:37:08 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
Message-ID: <20080819213708.GA5861@localhost>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <Pine.LNX.4.64.0808191049260.7877@shark.he.net> <20080819175440.GA5435@localhost> <Pine.LNX.4.64.0808191229330.7877@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808191229330.7877@shark.he.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:32:14PM -0700, Randy.Dunlap wrote:
> > > 
> > > Such as what?
> > > 
> > > Can marker probes be fixed instead?
> 
> Did you answer this?

Yes, they can be fixed, but the probe functions will likely show
warnings unless the way we parse vargs is fixed as well.

> > > After seeing & fixing lots of various warnings in the last few days,
> > > I'm thinking that people don't look at/heed warnings nowadays.  Sad.
> > > Maybe there are just so many that they are lost in the noise.
> > 
> > Hi,
> > 
> > Check the next patch in the series, it provides the alternate fix.
> 
> Yep, I saw that later.
> 
> > I favor this approach more because it involves fewer changes and we
> > don't have to use things like "%zu" (which make data type size less
> > apparent).
> 
> %zu is regular C language.  I.e., I don't get the data type not being
> apparent issue...

Yes, I know. But I feel like using unsigned long is consistent with the
way we handle the call site pointers and gfp_t. Pointers are cast to
unsigned long (in _RET_IP_) and size_t's actual range and size is more
apparent if it's cast to unsigned long as well (since allocation sizes
should scale the same as pointers do, and we know sizeof(unsigned long)
== sizeof(void *) on GCC).

> Maybe kmemtrace should just make everything be long long... :(

I was merely trying to sort this out faster and more consistent.

> -- 
> ~Randy
