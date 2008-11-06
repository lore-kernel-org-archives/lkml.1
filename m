Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYKFPGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYKFPGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYKFPGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:06:32 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:57387 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYKFPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:06:32 -0500
Date: Thu, 6 Nov 2008 09:05:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Dave Chinner <david@fromorbit.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 4/7] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <20081106035821.GA2373@disturbed>
Message-ID: <Pine.LNX.4.64.0811060905280.3595@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081105231648.462808759@quilx.com>
 <20081106035821.GA2373@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Dave Chinner wrote:

> On Wed, Nov 05, 2008 at 05:16:38PM -0600, Christoph Lameter wrote:
> > +
> > +#define __CPU_CMPXCHG(var, old, new)		\
> > +({						\
> > +	typeof(obj) x;				\
> > +	typeof(obj) *p = THIS_CPU(&(obj));	\
> > +	x = *p;					\
> > +	if (x == (old))				\
> > +		*p = (new);			\
> > +	(x);					\
> > +})
>
> I don't think that will compile - s/obj/var/ perhaps?

Correct.

