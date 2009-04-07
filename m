Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbZDGUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbZDGUXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZDGUXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:23:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12873 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbZDGUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:23:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jDKsIaGky4h/wTXWX4b4WRBC2d/lGmcL9n+SgS2Jc+rYC+xQmjySsvnvC9ObuG/Gi
	Yk3U7a6JuM+fMWVF0v0Vg==
Date: Tue, 7 Apr 2009 13:22:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <49DBB373.5050800@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Pekka Enberg wrote:

> > If you think that's acceptable, I'd be just as satisfied with that approach
> > as long as all archs have valid cpu_to_node() mappings at the time of
> > CPU_UP_PREPARE.
> 
> Well, that doesn't change the current behavior, so sure, I think it's
> acceptable. And if the new defaults seem reasonable enough, we can probably
> get rid of the tunable altogether.
> 

I'd like to remove MAX_PARTIAL and replace it with nr_cpu_ids.

The tunable still makes sense to increase slowpath performance by avoiding 
the page allocator on machines where memory is abundant.  That remains 
unchanged from when I added it.

> AFAICT, the Documentation/ABI directory is the right place for this kind of
> stuff.
> 

Ok.
