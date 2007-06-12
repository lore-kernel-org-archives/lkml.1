Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXFLKUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXFLKUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXFLKUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:20:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXFLKU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:20:29 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
Date: Tue, 12 Jun 2007 12:20:11 +0200
User-Agent: KMail/1.9.6
Cc: Adam Litke <agl@us.ibm.com>, dean gaudet <dean@arctic.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, clameter@sgi.com
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org> <1181597696.22671.2.camel@localhost.localdomain> <20070611213020.b3d91757.akpm@linux-foundation.org>
In-Reply-To: <20070611213020.b3d91757.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121220.11332.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Can we just double-check the refcounting please?
> 
> > index 4fefbad..8d2672d 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
> >  
> >  	if (sfd->vm_ops->get_policy)
> >  		pol = sfd->vm_ops->get_policy(vma, addr);
> 
> afacit this takes a ref on the underlying policy
> 
> > -	else
> > +	else if (vma->vm_policy)
> >  		pol = vma->vm_policy;
> > +	else
> > +		pol = current->mempolicy;
> 
> but these two do not.
> 
> >  	return pol;
> >  }
> >  #endif
> 
> Is is all correct?

No it looks broken.

-Andi
