Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbXHHPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbXHHPL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXHHPLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:11:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33640 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbXHHPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:11:47 -0400
Subject: Re: [RFC][PATCH 2/5] pagemap: use PAGE_MASK/PAGE_ALIGN()
From: Dave Hansen <haveblue@us.ibm.com>
To: Christian Ehrhardt <Christian_Ehrhardt@genua.de>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com
In-Reply-To: <200708080738.l787c6gP007376@felsenbeisser.genua.de>
References: <8PFSA-6mt-3@gated-at.bofh.it> <8PFSA-6mt-1@gated-at.bofh.it>
	 <200708080738.l787c6gP007376@felsenbeisser.genua.de>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 08:11:34 -0700
Message-Id: <1186585894.22283.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 09:38 +0200, Christian Ehrhardt wrote:
> 
> >       ret = -ENOMEM;
> > -     uaddr = (unsigned long)buf & ~(PAGE_SIZE-1);
> > +     uaddr = (unsigned long)buf & PAGE_MASK;
> >       uend = (unsigned long)(buf + count);
> > -     pagecount = (uend - uaddr + PAGE_SIZE-1) / PAGE_SIZE;
> > +     pagecount = (uend - PAGE_ALIGN(uaddr)) / PAGE_SIZE;
> 
> Unless I'm missing something the PAGE_ALIGN as ist stands is now a NOP
> because uaddr is already page aligned. You probably wanted to
> PAGE_ALIGN(uend). However, this will likely add an additional instruction
> to the generated code. 

Yeah, I aligned the wrong thing.  I'll fix that up.

-- Dave

