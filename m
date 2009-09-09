Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZIIEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZIIEPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZIIEPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:15:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZIIEPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:15:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TIFXEAp5SfzuoCaUVeUBxyay9LRj1HYfLicWttpPxadmIqOgmOm936MYG3K05OjkO
	rThxhkgnaFNzj7OXJzJuA==
Date: Tue, 8 Sep 2009 21:15:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <4AA724CB.1070401@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0909082110010.11909@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com> <4AA70D4F.3040503@cn.fujitsu.com> <alpine.DEB.1.00.0909081959030.5084@chino.kir.corp.google.com>
 <4AA72175.5000108@cn.fujitsu.com> <alpine.DEB.1.00.0909082034470.8334@chino.kir.corp.google.com> <4AA724CB.1070401@cn.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Li Zefan wrote:

> > Gack, ftrace_page would probably be better off simply using the flex list 
> > implementation I suggested which constructs a list from page->lru since it 
> > doesn't appear to require indexing into the array, it simply requires an 
> > iteration in all cases (or am I wrong?).  Flex lists could easily be made 
> > to support seqfiles.
> > 
> 
> Right, iteration is needed but indexing is not. I thought
> about flex list too, flex array has some limitations which
> make it hard to find a real user.
> 

I agree, the cgroup pidarray could be converted into a flex list 
implementation as well as ftrace_page, it appears.  All the metadata can 
be stored by overloading struct page and linking them in a dynamically 
expanding list on page->lru.

I'm thinking Andrew will want to see some user of this library in 2.6.32 
that cannot be served by a flex list type of implementation if we're to 
keep it merged in the kernel.
