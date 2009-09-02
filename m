Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZIBSvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZIBSvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZIBSvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:51:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZIBSvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:51:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PufaFraNJODOTF+qDNbMmLt8Qxi2tF8rUlz8sHn14yMDVTBcezRVe9hPbK35JkbUZ
	rsvH7bdRr+hDy4ToUSOHA==
Date: Wed, 2 Sep 2009 11:51:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2 -mm] flex_array: introduce DEFINE_FLEX_ARRAY
In-Reply-To: <1251912402.12395.634.camel@nimitz>
Message-ID: <alpine.DEB.1.00.0909021148420.9971@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909012013180.13377@chino.kir.corp.google.com> <1251912402.12395.634.camel@nimitz>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Dave Hansen wrote:

> This all looks pretty good.  The only issue is that the macro name
> lengths have gotten a bit out of hand.  
> 
> For instance.  This:
> 
> #define FLEX_ARRAY_ELEMENTS_PER_PART(size)                             \
>        (FLEX_ARRAY_PART_SIZE / size)
> 
> ends up being longer in practice than just open-coding the operation:
> 
> 	FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size)                      
> 
> vs.
> 
> 	(FLEX_ARRAY_PART_SIZE / fa->element_size)
> 
> and the length also ends up making for a couple of pretty ugly line
> wraps.
> 

Agreed, it's difficult to shorten because they need to be prefixed with 
FLEX_ARRAY_ since they are global macros now that they've been included in 
linux/flex_array.h.

> Otherwise, this is fine with me.
> 
> Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 

Thanks!
