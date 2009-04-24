Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZDXXfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZDXXfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZDXXfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:35:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZDXXfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:35:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=my0a3riPVFGD/a6Ifad4qas0ftPe+vqFZpdsmWfcyq+NR1lAuFcghjnEwuNB+fraX
	4vZBz7PKceT3F0dUg7KuQ==
Date: Fri, 24 Apr 2009 16:35:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add
 Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.1.10.0904231854130.26300@qirst.com>
Message-ID: <alpine.DEB.2.00.0904241626590.10046@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231510020.30545@chino.kir.corp.google.com> <alpine.DEB.1.10.0904231829550.26300@qirst.com>
 <alpine.DEB.2.00.0904231549130.32736@chino.kir.corp.google.com> <alpine.DEB.1.10.0904231854130.26300@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Christoph Lameter wrote:

> > I'm more concerned with the userspace API.  You're comfortable with
> > letting userspace determine what allocator the kernel is using either by
> > testing for the presence of certain slub or slqb-specific files or
> > checking the config?
> 
> Why would userspace have to test? If the fields have the same semantics
> then we are fine.
> 

For a robust init script to determine which allocator the kernel is using, 
it must either do `zgrep CONFIG_SLQB=y /proc/config.gz` or 
if [ -e /sys/kernel/slab/cache/hiwater ], for example.  The latter is more 
delicate because the API could change or (even worse) another allocator, 
present or future, could include a `hiwater' attribute.

> > That should be fine since there's parity among the files that both
> > allocators share, but seems fragile if an allocator adds a file that was
> > previously only applicable to the other or the API happens to change.
> 
> Right. The newly added file must not be in use by another allocator.
> 

Yeah, at least with different semantics or side effects.

> > My thinking was that /sys/kernel/slqb would be a permanent reference point
> > that userspace could easily test to determine what API is available.
> 
> The API is hopefully generic enought to accomodate all allocators.
> 

Ok, fair enough.

SLQB will need to update this file and hopefully it doesn't become too 
terribly complex.
