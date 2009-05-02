Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZEBVmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZEBVmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZEBVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:42:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33047 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbZEBVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:42:44 -0400
Subject: Re: [RFC][PATCH 17/35] sparc: create ptemap.h
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Daniel K." <dk@uw.no>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49FBF00F.5030700@uw.no>
References: <20090501144201.D31EF417@kernel>
	 <20090501144227.3FFE505C@kernel>  <49FBF00F.5030700@uw.no>
Content-Type: text/plain
Date: Sat, 02 May 2009 14:42:42 -0700
Message-Id: <1241300562.9131.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-02 at 07:02 +0000, Daniel K. wrote:
> Dave Hansen wrote:
> > -/* Certain architectures need to do special things when pte's
> > - * within a page table are directly modified.  Thus, the following
> > - * hook is made available.
> > - */
> 
> This is FUBAR'ed, The comment refers to the BTFIXUPDEF_CALL below, and should not
> be moved to asm/ptemap.h 

Thanks for looking through this.  I've fixed this up in my most recent
version.

> > + * This shortcut works on sun4m (and sun4d) because the nocache area is static,
> > + * and sun4c is guaranteed to have no highmem anyway.
> > + */
> 
> Broken comment.
> 
> > +#define pte_offset_map(d, a)		pte_offset_kernel(d,a)
> > +#define pte_offset_map_nested(d, a)	pte_offset_kernel(d,a)
> > +
> > +#define pte_unmap(pte)		do{}while(0)
> > +#define pte_unmap_nested(pte)	do{}while(0)
> > +
> > +#endif
> > +
> > +#endif /* _SPARC_ASM_PTEMAP_H *//*
> 
> Broken comment.
> 
> I realize this is going away in the end, but all the interim steps should
> compile, to aid bisection.

Yup, absolutely.  This is fixed up now, too.

-- Dave

