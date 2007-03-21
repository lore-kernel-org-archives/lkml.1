Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbXCUPHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbXCUPHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXCUPHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:07:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40979 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbXCUPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:07:16 -0400
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
	helper macros.
From: Arjan van de Ven <arjan@infradead.org>
To: Adam Litke <agl@us.ibm.com>
Cc: Dave Hansen <hansendc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1174488630.21684.5.camel@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
	 <20070319200513.17168.52238.stgit@localhost.localdomain>
	 <1174433081.26166.168.camel@localhost.localdomain>
	 <1174488630.21684.5.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 21 Mar 2007 16:05:08 +0100
Message-Id: <1174489509.1158.127.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 09:50 -0500, Adam Litke wrote:
> On Tue, 2007-03-20 at 16:24 -0700, Dave Hansen wrote:
> > On Mon, 2007-03-19 at 13:05 -0700, Adam Litke wrote:
> > > 
> > > +#define has_pt_op(vma, op) \
> > > +       ((vma)->pagetable_ops && (vma)->pagetable_ops->op)
> > > +#define pt_op(vma, call) \
> > > +       ((vma)->pagetable_ops->call) 
> > 
> > Can you get rid of these macros?  I think they make it a wee bit harder
> > to read.  My brain doesn't properly parse the foo(arg)(bar) syntax.  
> > 
> > +       if (has_pt_op(vma, copy_vma))
> > +               return pt_op(vma, copy_vma)(dst_mm, src_mm, vma);
> > 
> > +       if (vma->pagetable_ops && vma->pagetable_ops->copy_vma)
> > +               return vma->pagetable_ops->copy_vma(dst_mm, src_mm, vma);
> > 
> > I guess it does lead to some longish lines.  Does it start looking
> > really nasty?
> 
> Yeah, it starts to look pretty bad.  Some of these calls are in code
> that is already indented several times.

can we just make sure these things are never NULL in the first place?
would obsolete a lot of the checks, which are also runtime overhead as
well!
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

