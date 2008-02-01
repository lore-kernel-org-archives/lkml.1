Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYBAPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYBAPgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYBAPgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:36:04 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2991 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYBAPgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:36:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=tviVPu++E2EDwEKP6bfYozK6G8z3NU+ZwLGa5ydVtaWZ3cPTrX/ENhB5IPd1hzQtv
	kVlI3PkQWF+tJWmnKmILA==
Message-ID: <6599ad830802010735y1caac967sb12a96b7d54f4ca3@mail.gmail.com>
Date: Fri, 1 Feb 2008 07:35:46 -0800
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Default child of a cgroup
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, containers@lists.osdl.org,
       dhaval@linux.vnet.ibm.com, "Balbir Singh" <balbir@in.ibm.com>,
       pj@sgi.com
In-Reply-To: <1201852712.32654.36.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080131024049.GA9544@linux.vnet.ibm.com>
	 <6599ad830801311839x33cf2ebco9f501571fc129b11@mail.gmail.com>
	 <1201852712.32654.36.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 11:58 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Is there a restriction in CFS that stops a given group from
> > simultaneously holding tasks and sub-groups? If so, couldn't we change
> > CFS to make it possible rather than enforcing awkward restrictions on
> > cgroups?
>
> I think it is possible, just way more work than the proposed hack.

Seems to me like the right thing to do though.

>
> > If we really can't change CFS in that way, then an alternative would
> > be similar to Peter's suggestion - make cpu_cgroup_can_attach() fail
> > if the cgroup has children, and make cpu_cgroup_create() fail if the
> > cgroup has any tasks - that way you limit the restriction to just the
> > hierarchy that has CFS attached to it, rather than generically for all
> > cgroups
>
> Agreed.
>

Actually, I realised later that this is impossible - since the root
cgroup will have tasks initially, there'd be no way to create the
first child cgroup in the CFS hierarchy.

Paul
