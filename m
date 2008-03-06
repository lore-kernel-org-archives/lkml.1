Return-Path: <linux-kernel-owner+w=401wt.eu-S935349AbYCFUw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935349AbYCFUw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbYCFUwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:52:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762723AbYCFUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:51:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=XcAuL5+AfLen13V0713Etx91M9VTbC0HtnL2dHU8aW42sxGzyS9ICmADqjmwCW6oZ
	rBg/Tedq79XxV9l5m/VQw==
Date: Thu, 6 Mar 2008 12:51:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 4/4] mempolicy: remove includes for duplicate
 headers
In-Reply-To: <20080306141923.45ce4214.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0803061244560.31802@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com> <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com> <alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com> <alpine.DEB.1.00.0803061136320.18590@chino.kir.corp.google.com>
 <20080306141923.45ce4214.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Paul Jackson wrote:

> > Remove #includes for:
> > 
> > 	linux/mempolicy.h	(already from linux/migrate.h)
> > 	linux/mm.h		(already from linux/highmem.h)
> 
> I didn't see any problem offhand with the other patches 0 to 3 in this
> set, but this patch 4/4 surprises me.
> 
> Perhaps I'm out of phase with what's customary in the kernel, but I
> prefer directly including whatever headers I explicitly need.
> Depending on some other header to drag in something you have explicit
> need of anyway makes things more fragile.
> 

It simply decreases the remote chance later that we'll develop obscure 
header file dependencies for some archs like we saw with the memcontroller 
and the sparc build.  There are no strange dependencies that I am 
currently aware of, so this is not a bugfix.

The only way this would make things more fragile is if a header file 
removes an include for another header file without checking all the users 
of the former first and fixing it up in mm/mempolicy.c.
