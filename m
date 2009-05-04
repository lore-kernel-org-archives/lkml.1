Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZEDKBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZEDKBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZEDKBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:01:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:25797 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZEDKBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SwjKntKxLurXZ8A561w8JyowceL/p0pqlLPEOXVCzZUQv3O70TQeBLhQ4pXXi9mxOD
         TxtstXm8EML07Lj/u3a+jMF9LW+g3HbQWCJ6pjsgrGityPW/tBuYiattZI9BBG8E0QIY
         lE1GjJ5EB5abzyfiqeOPYlH/7WrNIzeM2+I8Q=
Date: Mon, 4 May 2009 14:01:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504100106.GD4173@lenovo>
References: <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com> <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop> <20090504090825.GC4173@lenovo> <1241431031.21088.21.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241431031.21088.21.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, May 04, 2009 at 12:57:11PM +0300]
| On Mon, 2009-05-04 at 13:08 +0400, Cyrill Gorcunov wrote:
| > Index: linux-2.6.git/mm/oom_kill.c
| > =====================================================================
| > --- linux-2.6.git.orig/mm/oom_kill.c
| > +++ linux-2.6.git/mm/oom_kill.c
| > @@ -422,6 +422,16 @@ static int oom_kill_process(struct task_
| >  	return oom_kill_task(p);
| >  }
| >  
| > +void oom_panic(gfp_t gfp_mask, unsigned int order)
| > +{
| > +	if (likely(!(gfp_mask & __GFP_PANIC)))
| > +		return;
| > +
| > +	panic("Out of memory: panic due to __GFP_PANIC.\n"
| > +		"%s order:%d, mode:0x%x\n", current->comm,
| > +		order, gfp_mask);
| > +}
| 
| I think this just makes things harder to follow. It has one call-site so
| why not inline this there?
| 

Indeed, will fix shortly, thanks.

	-- Cyrill
