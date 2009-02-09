Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZBIU3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZBIU3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbZBIU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:28:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:47212 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZBIU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hCBEAn0id8j3Iv9VWm2AQ1HIHdXMdxG5/wQCDk2leyzD+zEYxUMwMvymDvElxnToVE
         lFY2yogKo52yFcE4abA0te3iXkRxaRgWLJC+G3NP/QNW/sRwV8GurIw06zgRXXsbNSb2
         hJrv/GN2j8OGNDYeiMnai7xU2LanRxqN0Z5cA=
Date: Mon, 9 Feb 2009 23:35:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: include/linux/irq.h:452: error: implicit declaration of
	function 'cpu_to_node'
Message-ID: <20090209203502.GA7701@x200.localdomain>
References: <20090121215306.GA10123@x200.localdomain> <4977B1F1.1090602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4977B1F1.1090602@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 03:38:25PM -0800, Mike Travis wrote:
> Alexey Dobriyan wrote:
> > On mips-malta:
> > 
> >   CC      arch/mips/mti-malta/malta-int.o
> > In file included from arch/mips/mti-malta/malta-int.c:25:
> > include/linux/irq.h: In function 'init_alloc_desc_masks':
> > include/linux/irq.h:452: error: implicit declaration of function 'cpu_to_node'
> > include/linux/irq.h:454: error: 'GFP_ATOMIC' undeclared (first use in this function)
> > 
> > I _think_ init_alloc_desc_masks() should be made out of line to fix this.
> 
> Hi Alexey,
> 
> Does adding #include <linux/slab.h> fix the error?  If so, I can add this to
> linux/irq.h.
> 
> The primary reason it's inline is that unless CONFIG_CPUMASK_OFFSTACK=y, then the
> entire routine is a NOP which optimizes out more completely as an inline function.

linux/slab.h helps.
