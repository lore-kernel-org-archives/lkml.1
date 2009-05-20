Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZETQNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZETQNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZETQNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:13:08 -0400
Received: from relay1.sgi.com ([192.48.179.29]:52898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754414AbZETQNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:13:07 -0400
Date: Wed, 20 May 2009 11:13:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 - UV fix for memory-only blades
Message-ID: <20090520161304.GE13409@sgi.com>
References: <20090515194508.GA8305@sgi.com> <4A12CC81.30108@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A12CC81.30108@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 08:13:05AM -0700, Yinghai Lu wrote:
> Jack Steiner wrote:
> > Fix an endcase in handling UV blades that have memory
> > but no cpus. The calculation of the highest blade number
> > failed to handle these blades if they appear last in the
> > configuration.
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> > 
> > ---
> >  arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-05-15 12:00:59.000000000 -0500
> > +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-05-15 14:38:16.000000000 -0500
> > @@ -632,6 +632,7 @@ void __init uv_system_init(void)
> >  		pnode = (paddr >> m_val) & pnode_mask;
> >  		blade = boot_pnode_to_blade(pnode);
> >  		uv_node_to_blade[nid] = blade;
> > +		max_pnode = max(pnode, max_pnode);
> >  	}
> >  
> >  	map_gru_high(max_pnode);
> 
> node_possible_map should already include nodes with memory and without memory already.
> 
> maybe you could skip max_pnode calculating in the loop.

Terms related to nodes are grossly overloaded.

"pnode" is only loosely related to a node. It is a physical node number that
is a hardware-thing. For example, it is possible to have a 1 node system with a max_pnode
of 128. 

pnodes are used only in the UV infrastructure - they have no generic meaning nor would they apply
to any other platform.


--- jack
