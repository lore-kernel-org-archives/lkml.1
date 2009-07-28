Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbZG1FBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbZG1FBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZG1FBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:01:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZG1FBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:01:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=an4lvhJpUMAL/5SQpdLCNGMmJewJ4HUXHJ31osV8AHCbSMtj+BWI5fpGyGoBf/0BX
	SaytfbluoPKVAq9K/j47w==
Date: Mon, 27 Jul 2009 22:01:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: Make it easier to catch NULL cache names
In-Reply-To: <1248749739.30993.39.camel@pasglop>
Message-ID: <alpine.DEB.2.00.0907272200520.22207@chino.kir.corp.google.com>
References: <1248745735.30993.38.camel@pasglop> <alpine.LFD.2.01.0907271951390.3186@localhost.localdomain> <1248749739.30993.39.camel@pasglop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Benjamin Herrenschmidt wrote:

> > Please don't do BUG_ON() when there are alternatives.
> > 
> > In this case, something like
> > 
> > 	if (WARN_ON(!name))
> > 		return NULL;
> > 
> > would probably have worked too.
> 
> Fair enough..  I'll send a new patch.
> 

Actually needs goto err, not return NULL, to appropriately panic when 
SLAB_PANIC is set.
