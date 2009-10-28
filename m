Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbZJ1JDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbZJ1JDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbZJ1JDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:03:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34729 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbZJ1JDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:03:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Lq71quemDlxSKUVxSrZioe7RGfFbF1TCSRd0Tfo6FMxr8OnV86WyFP+Kf+fNcMnFk
	uo1OTflyinD1f5IQDKJYA==
Date: Wed, 28 Oct 2009 02:03:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Alex Chiang <achiang@hp.com>, Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
 sysfs
In-Reply-To: <20091028083137.GA24140@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com> <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
 <20091028083137.GA24140@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Heiko Carstens wrote:

> The short answer is: s390 doesn't support NUMA, because the hardware doesn't
> tell us to which node (book in s390 terms) a memory range belongs to.
> 
> Memory layout for a logical partition is striped: first x mbyte belong to
> node 0, next x mbyte belong to node 1, etc...
> 
> Also, since there is always a hypervisor running below Linux I don't think
> it would make too much sense if we would know to which node a piece of
> memory belongs to: if the hypervisor decides to schedule a virtual cpu of
> a logical partition to a different node then what?
> 

Ok, so the patchset is a no-op for s390 since it only utilizes the 
!CONFIG_NUMA code.

Alex, I think the safest thing to do in unregister_mem_sect_under_nodes() 
is to iterate though the section pfns and remove links to the node_device 
kobjs for all the distinct pfn_to_nid()'s that it encounters.
