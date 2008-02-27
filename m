Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbYB0UBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbYB0UBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbYB0UA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:00:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbYB0UAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:00:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=x+M4oq5QPMToQ4iQ+rD91sFmhEPHHTLxvm9wcaPYMaUUORREwPFye7XPyK1DdnCCg
	kfB1NTO3+OvyMLyZrEh7A==
Date: Wed, 27 Feb 2008 11:59:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
In-Reply-To: <Pine.LNX.4.64.0802271134150.1790@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.1.00.0802271152570.313@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <Pine.LNX.4.64.0802271134150.1790@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Christoph Lameter wrote:

> On Mon, 25 Feb 2008, David Rientjes wrote:
> 
> >  struct mempolicy {
> >  	atomic_t refcnt;
> > -	short policy; 	/* See MPOL_* above */
> > +	unsigned short policy; 	/* See MPOL_* above */
> 
> The point here is to have a 16 bit value? There are no space savins due to 
> the alignment requirement of the union. Isnt it possible to use the enum 
> here? If not then what is the point of the enum?
> 

It was already a 16-bit value, that is unchanged, so no space savings is 
intended.

It is not possible to use the enum here because an additional unsigned 
short member to hold the mode flags is added to this struct later.  The 
increase in size of an int compared to an unsigned short would make the 
entire struct bigger; the alignment requirement of the union no longer 
prevents that.  After this patchset, it is 24 bytes in size while using 
unsigned short compared to 32 bytes while using int.

The enum is there to ensure MPOL_MAX is always accurate since it is now 
the sole way of testing for a proper mode being passed from the user, and
modes should be sequentially numbered.  A later change will add an array 
instance of a mempolicy_operations structure for the various modes.  It's 
just cleaner.

		David
