Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbZFQA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbZFQA2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZFQA2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:28:11 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:45362 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752492AbZFQA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:28:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TyoPCQWdQDT8IWlDuHx9R1xhMlYNTT0FFHdDxVgXzpPvtb2iRN4m12sfAl0hpdDBNvw9EQy/vlOewqc6pEc4tmSz5lyRIAB+FEFyGBLEEHWIuNvsuebnTK1ZJDhjs9NW;
Date: Tue, 16 Jun 2009 17:28:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
Message-ID: <20090616172811.7f6374f4@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
	<alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>
	<1245192703.8234.226.camel@bluto.andrew>
	<alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
	<1245195498.8234.236.camel@bluto.andrew>
	<alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 16:56:12 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 16 Jun 2009, Andrew Patterson wrote:
> > > 
> > > Well, find_resource() found room for a resource. So it returns
> > > it. The point is, your patch returns another - equally valid one.
> > 
> > I am confused.  The existing code will return a conflict and bomb
> > out.
> 
> My point is, there are two answers - returning the conflicting
> resource, or trying to recurse into it. Both are "valid", in the
> sense that both have real semantics.
> 
> But the reason I don't like your patch is that I think the _deeper_ 
> problem is the fact that the resource tree isn't set up right in the
> first place.
> 
> It looks to me like your patch works around the bug (by trying to
> find that "other possible case"), while my disagreement with that
> patch is that we should never need to care about these kinds of "you
> can try to find ambiguous cases" in the first place.
> 
> > > We've had those kinds of situations before. The thread you point
> > > to is an exact case of this. My point is that I'd rather try to
> > > _avoid_ any ambiguous cases, and try to solve it properly at a
> > > higher PCI level, where the ambiguity doesn't exist any more
> > > (because we'd explicitly take the actual bus topology into
> > > account). So your patch may fix a bug, but I'm pretty sure I've
> > > seen a patch from Ivan that should _also_ fix it, and that I
> > > would expect to do it not by just tweaking a fundamentally
> > > ambiguous case.
> > 
> > OK. I would be happy to test Ivan's patch.
> 
> I just looked at our PCI bus resource allocation code, and afaik it
> does everything right even as-is. Which is why I now wonder if that
> incorrectly nested bus resource was perhaps set up by the PCI hotplug
> code (which I do not know, and didn't look at). 
> 
> I may also be confused, and not have found the right place that
> actually inserts the resource. Afaik, bus resources get allocated
> through
> 
> 	pbus_assign_resources_sorted ->
> 	  pci_assign_resource ->
> 	    pci_bus_alloc_resource ->
> 	      allocate_resource
> 
> and that "pci_bus_alloc_resource()" thing only allocates within the
> parent bus, so it _should_ nest correctly.
> 
> It would be interesting to see where that resource actually gets 
> allocated. I'm clearly missing something, since clearly your
> resources do _not_ nest correctly.

Alex has been fixing up hotplug related code recently too; Alex?  Also
you didn't actually include a patch in your last mail that I could
see...

-- 
Jesse Barnes, Intel Open Source Technology Center
