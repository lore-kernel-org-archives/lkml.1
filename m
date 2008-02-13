Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYBMDRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYBMDRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYBMDRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:17:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:47209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYBMDRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:17:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=h0dzwK9oHVFft36duKmaidlY48eD5UJ3RnI+HpKn64UvhhcqgpuRZqla0bjz3TwOc
	SvSc8+l438y5RUGhnfhiw==
Date: Tue, 12 Feb 2008 19:17:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080212205944.86ab2dc7.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802121911040.3418@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <1202861432.4974.29.camel@localhost> <20080212183158.3ff4ccd5.pj@sgi.com> <Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com> <20080212193229.edbff05a.pj@sgi.com>
 <alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com> <20080212202201.a534cef8.pj@sgi.com> <alpine.DEB.1.00.0802121832520.29792@chino.kir.corp.google.com> <20080212205944.86ab2dc7.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> ==> If each time I look at some 'flags' field, I have to think of it
> as a couple of things glued together that I will have to pick apart to
> use, that's more mental work than seeing those two things explicit and
> separate, through most of the mempolicy.c code <==
> 

That doesn't logically follow because the aggregate of the mode and the 
optional flags _are_ the policy itself.  If you want to know whether a 
policy is interleave, for example, and don't care whether it is referring 
to static (absolute) node ids, then you need to mask that off.

The reality of the kernel code is that these policies are not only 
restricted to kernel/mempolicy.c.  They are also shared with filesystem 
code that store them in a single member of a struct as well.  The 
interface between those two are functions that would now need to be 
modified to include additional parameters to pass the flags along.

Additionally, these flags need to be "glued together" with the mode in 
userspace to pass to the syscalls anyway, so they're facing the exact 
same challenge.  So once this gets a little traction, I think it will 
quickly become the norm for how you think about the 'policy' member of the 
struct.

		David
