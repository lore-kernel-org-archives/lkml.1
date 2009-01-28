Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZA1JUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZA1JUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZA1JUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:20:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZA1JUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:20:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=qhcuRU+vre/fIZjna8L4mzJrN6HzdkOftj+dzqh6Lf/7B3lwDaGSVc00mt+wLxLC8
	EhKnL83P7tqEBSXASAx9Q==
Date: Wed, 28 Jan 2009 01:20:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: fix per cpu kmem_cache_cpu array memory leak
In-Reply-To: <84144f020901280058h36fedf37j600185c255db5e2a@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901280115470.28944@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>  <1233132733.16201.0.camel@penberg-laptop> <84144f020901280058h36fedf37j600185c255db5e2a@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Pekka Enberg wrote:

> Btw, did you hit this bug during testing or did you just spot it
> during review? That is, do we need to get this to -stable?
> 

I ran into it while hacking the per cpu arrays, but haven't witnessed it 
on a vanilla kernel.  Since there are no guarantees that a kmem_cache_cpu 
will not be allocated on this boundary, I would recommend it for -stable.
