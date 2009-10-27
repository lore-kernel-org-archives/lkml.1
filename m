Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbZJ0V2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbZJ0V2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbZJ0V2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:28:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbZJ0V2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:28:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jgSmilqaaOPBvsIzyobPkG5NnP0kjVpYWRQcMWyEnrKzDGKJjUO+ATngDw5/x0Jya
	xwrEnKC/0/IGTAJUpeQyw==
Date: Tue, 27 Oct 2009 14:27:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Gary Hade <garyhade@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
 sysfs
In-Reply-To: <20091027195907.GJ14102@ldl.fc.hp.com>
Message-ID: <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Alex Chiang wrote:

> Thank you for ACKing, David.
> 
> S390 guys, I cc'ed you on this patch because I heard a rumour
> that your memory sections may belong to more than one NUMA node?
> Is that true? If so, how would you like me to handle that
> situation?
> 

You're referring to how unregister_mem_sect_under_nodes() should be 
handled, right?  register_mem_sect_under_node() already looks supported by 
your patch.

Since the unregister function includes a plural "nodes," I assume that 
it's possible for hotplug to register a memory section to more than one 
node.  That's probably lacking on x86 currently, however, because we lack 
node hotplug.

I'd suggest a similiar iteration through pfn's that the register function 
does checking for multiple nodes and then removing the link from all 
applicable node_devices kobj when unregistering.

Maybe one of the s390 maintainers will test that?
