Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbZJ1Ibo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbZJ1Ibo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbZJ1Ibn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:31:43 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48398 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbZJ1Ibl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:31:41 -0400
Date: Wed, 28 Oct 2009 09:31:38 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Alex Chiang <achiang@hp.com>, Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
 sysfs
Message-ID: <20091028083137.GA24140@osiris.boeblingen.de.ibm.com>
References: <20091022040814.15705.95572.stgit@bob.kio>
 <20091022041510.15705.5410.stgit@bob.kio>
 <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com>
 <20091027195907.GJ14102@ldl.fc.hp.com>
 <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 02:27:56PM -0700, David Rientjes wrote:
> On Tue, 27 Oct 2009, Alex Chiang wrote:
> 
> > Thank you for ACKing, David.
> > 
> > S390 guys, I cc'ed you on this patch because I heard a rumour
> > that your memory sections may belong to more than one NUMA node?
> > Is that true? If so, how would you like me to handle that
> > situation?
> > 
> 
> You're referring to how unregister_mem_sect_under_nodes() should be 
> handled, right?  register_mem_sect_under_node() already looks supported by 
> your patch.
> 
> Since the unregister function includes a plural "nodes," I assume that 
> it's possible for hotplug to register a memory section to more than one 
> node.  That's probably lacking on x86 currently, however, because we lack 
> node hotplug.
> 
> I'd suggest a similiar iteration through pfn's that the register function 
> does checking for multiple nodes and then removing the link from all 
> applicable node_devices kobj when unregistering.
> 
> Maybe one of the s390 maintainers will test that?

The short answer is: s390 doesn't support NUMA, because the hardware doesn't
tell us to which node (book in s390 terms) a memory range belongs to.

Memory layout for a logical partition is striped: first x mbyte belong to
node 0, next x mbyte belong to node 1, etc...

Also, since there is always a hypervisor running below Linux I don't think
it would make too much sense if we would know to which node a piece of
memory belongs to: if the hypervisor decides to schedule a virtual cpu of
a logical partition to a different node then what?
