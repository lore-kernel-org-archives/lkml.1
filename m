Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZGARcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZGARcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZGARcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:32:08 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41206 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZGARcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:32:07 -0400
Date: Wed, 1 Jul 2009 18:37:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Greg KH <gregkh@suse.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
In-Reply-To: <20090701111003.GC15958@elte.hu>
Message-ID: <alpine.LFD.2.00.0907011816070.18056@eddie.linux-mips.org>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de> <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org> <20090701111003.GC15958@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Ingo Molnar wrote:

> >  ENOTIME, sorry.  Next year perhaps.  Or a homework project for 
> > one of the newbies. ;)
> 
> You know that this project would kill a newbie, right? :)

 Well, that's just a fast track to become a veteran, isn't it? ;)

> We have no real southbridge drivers on x86 - but we should certainly 
> add some. Also, walking the PCI device tree from NMI context is 
> tricky as the lists there are not NMI safe - we could crash if we 
> happen to get a #IOCK while loading/unloading drivers (which is rare 
> but could happen).

 That shouldn't be a problem if we were about to panic().  For a more 
sophisticated attempt of recovery -- yes, that would have to be addressed.  

 The possibly simplest approach could be keeping a local list of PCI 
configuration space addresses of the PCI status (and secondary status, as 
applicable) register of all the currently present devices.  That would 
still require some care as many northbridges do not provide means for 
atomic PCI config accesses and a NMI could happen because of some other 
than the CPU master's activity in the middle of a regular config access 
being done by the CPU.  So e.g. the config address register would have to 
be restored so that the regular config data access goes to the right 
location once the NMI handler has concluded.  But that does not sound as 
complicated as traversing the regular structures.

> IMHO it's all very much desired functionality, but highly 
> non-trivial.

 Memory ECC error handlers would benefit from some southbridge 
infrastructure too.

  Maciej
