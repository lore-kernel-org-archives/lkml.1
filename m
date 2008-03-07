Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYCGVth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYCGVth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYCGVtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:49:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:48776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYCGVtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:49:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=USyLvxx+i2ftMoFRtrjIyakxQZLm1b253LymC6D1nlvnfZQnPMWSUn3DRl5sZkG0K
	IeAlwrvhzuCNLyTJj6xIA==
Date: Fri, 7 Mar 2008 13:48:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: Regression:  Re: [patch -mm 2/4] mempolicy: create mempolicy_operations
 structure
In-Reply-To: <1204922646.5340.73.camel@localhost>
Message-ID: <alpine.DEB.1.00.0803071341090.26765@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>  <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com> <1204922646.5340.73.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Lee Schermerhorn wrote:

> It also appears that the patch series listed above required a non-empty
> nodemask with MPOL_DEFAULT.  However, I didn't test that.  With this
> patch, MPOL_DEFAULT effectively ignores the nodemask--empty or not.
> This is a change in behavior that I have argued against, but the
> regression tests don't test this, so I'm not going to attempt to address
> it with this patch.
> 

Excuse me, but there was significant discussion about this on LKML and I 
eventually did force MPOL_DEFAULT to require a non-empty nodemask 
specifically because of your demand that it should.  It didn't originally 
require this in my patchset, and now you're removing the exact same 
requirement that you demanded.

You said on February 13:

	1) we've discussed the issue of returning EINVAL for non-empty
	nodemasks with MPOL_DEFAULT.  By removing this restriction, we run
	the risk of breaking applications if we should ever want to define
	a semantic to non-empty node mask for MPOL_DEFAULT.

If you want to remove this requirement now (please get agreement from 
Paul) and are sure of your position, you'll at least need an update to 
Documentation/vm/numa-memory-policy.txt.
