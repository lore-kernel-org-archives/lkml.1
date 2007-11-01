Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbXKATB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbXKATB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXKATBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:01:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42799 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbXKATBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:01:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=lnNGRYYQLMxlhkunWtKNFH79UA7OriHyS2WQq7a7tJ27ZLiCsL8u8GjPxwVN8DGbo
	zs0AbrjlQLVVWi7Hn4rrg==
Date: Thu, 1 Nov 2007 12:00:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031214719.81f8293a.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0711011153590.21823@chino.kir.corp.google.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com> <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

> With the mode bit as in my patch, there are fewer places in the user
> code that have to be gotten just right.  With your way, each and
> every mbind and *_mempolicy call has to be hacked with the new flag
> if one is going to use the new nodemask bit numbering.

That code is going to have to be hacked anyway to use the new nodemask 
semantics, so it can easily add a flag to the set_mempolicy() call for the 
system-wide node numbering.  This then only requires a small addition to 
the documentation: use MPOL_F_MODE_SYS_WIDE for system-wide node numbering 
that isn't constrained to your cpuset.

> Some of these
> calls might be inside other routines or libraries that aren't readily
> available to be examined or changed.  If you miss one, or forget to
> add one when adding more mbind or *_mempolicy calls in the future,
> then you have a nasty lurking hidden performance bug due to misplaced
> pages in certain configurations.  That too is a serious maintenance
> nightmare, as I've already tried to describe.
> 

That's a very legitimate concern, but those libraries will eventually need 
to be made to support this new extention anyway.  They will be modified 
just like we're modifying the kernel once people want to start using the 
different nodemask semantics.  As mempolicy modes become more popular, 
those libraries are going to start accepting custom mode flags to pass to 
their set_mempolicy() wrappers that will get OR'd with the mempolicy mode 
that is used.  It will be the natural progression of how mempolicies are 
supported in userspace.

		David
