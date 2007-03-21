Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXCUOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXCUOun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXCUOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:50:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57395 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXCUOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:50:40 -0400
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
	helper macros.
From: Adam Litke <agl@us.ibm.com>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1174433081.26166.168.camel@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
	 <20070319200513.17168.52238.stgit@localhost.localdomain>
	 <1174433081.26166.168.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 09:50:30 -0500
Message-Id: <1174488630.21684.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 16:24 -0700, Dave Hansen wrote:
> On Mon, 2007-03-19 at 13:05 -0700, Adam Litke wrote:
> > 
> > +#define has_pt_op(vma, op) \
> > +       ((vma)->pagetable_ops && (vma)->pagetable_ops->op)
> > +#define pt_op(vma, call) \
> > +       ((vma)->pagetable_ops->call) 
> 
> Can you get rid of these macros?  I think they make it a wee bit harder
> to read.  My brain doesn't properly parse the foo(arg)(bar) syntax.  
> 
> +       if (has_pt_op(vma, copy_vma))
> +               return pt_op(vma, copy_vma)(dst_mm, src_mm, vma);
> 
> +       if (vma->pagetable_ops && vma->pagetable_ops->copy_vma)
> +               return vma->pagetable_ops->copy_vma(dst_mm, src_mm, vma);
> 
> I guess it does lead to some longish lines.  Does it start looking
> really nasty?

Yeah, it starts to look pretty bad.  Some of these calls are in code
that is already indented several times.

> If you're going to have them, it might just be best to put a single
> unlikely() around the macro definitions themselves to keep anybody from
> having to open-code it for any of the users.  

It should be pretty easy to wrap has_pt_op() with an unlikely().  Good
suggestion.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

