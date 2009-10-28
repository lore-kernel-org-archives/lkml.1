Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZJ1RP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZJ1RP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZJ1RP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:15:57 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:33096 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZJ1RP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:15:56 -0400
Date: Wed, 28 Oct 2009 11:15:58 -0600
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
	sysfs
Message-ID: <20091028171558.GB22743@ldl.fc.hp.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com> <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com> <20091028083137.GA24140@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com>:
> On Wed, 28 Oct 2009, Heiko Carstens wrote:
> 
> > The short answer is: s390 doesn't support NUMA, because the hardware doesn't
> > tell us to which node (book in s390 terms) a memory range belongs to.
> > 
> > Memory layout for a logical partition is striped: first x mbyte belong to
> > node 0, next x mbyte belong to node 1, etc...
> > 
> > Also, since there is always a hypervisor running below Linux I don't think
> > it would make too much sense if we would know to which node a piece of
> > memory belongs to: if the hypervisor decides to schedule a virtual cpu of
> > a logical partition to a different node then what?
> > 
> 
> Ok, so the patchset is a no-op for s390 since it only utilizes the 
> !CONFIG_NUMA code.

Sounds good.

> Alex, I think the safest thing to do in unregister_mem_sect_under_nodes() 
> is to iterate though the section pfns and remove links to the node_device 
> kobjs for all the distinct pfn_to_nid()'s that it encounters.

Ok, I will respin.

Thanks!
/ac
