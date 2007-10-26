Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbXJZCpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbXJZCpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXJZCpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:45:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50966 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbXJZCpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:45:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=o+Hvk/nUwPt6sxl9gsEEJYUqLbo4XgVhOVCpZvteN/q3wxEgiSCNVMSHIfXR+f5Wt
	SEdQeCxk8R9LWUbaoAh8g==
Date: Thu, 25 Oct 2007 19:45:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071025192945.82962eea.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <20071025192945.82962eea.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Paul Jackson wrote:

> Are you seeing this in a real world situation?  Can you describe the
> situation?  I don't mean just describing how it looks to this kernel
> code, but what is going on in the system, what sort of job mix or
> applications, what kind of users, ...  In short, a "use case", or brief
> approximation thereto.  See further:
> 

Yes, when using cpusets for resource control.  If memory pressure is being 
felt for that cpuset and additional mems are added to alleviate possible 
OOM conditions, it is insufficient to allow tasks within that cpuset to 
continue using memory policies that prohibit them from taking advantage of 
the extra memory.

The best remedy for that situation is to give the cpuset owner the option 
of allowing tasks with MPOL_INTERLEAVE policies to always interleave over 
the entire set of available mems so they can be dynamically expanded and 
contracted at will without triggering OOM conditions.

> Do you have a link to what Lee proposed?  I agree that a full general
> solution would seem to require a new or changed set_mempolicy API,
> which may well be more than we want to do, absent a more compelling
> "use case" requiring it than we have now.
> 

http://marc.info/?l=linux-mm&m=118849999128086
