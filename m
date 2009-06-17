Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbZFQQqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbZFQQqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbZFQQqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:46:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758585AbZFQQqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:46:38 -0400
Date: Wed, 17 Jun 2009 09:45:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1245215916.5604.5.camel@penberg-laptop>
Message-ID: <alpine.LFD.2.01.0906170941490.16802@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>  <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> 
 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>  <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>  <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>  <1245101567.12400.38.camel@pasglop>
  <alpine.DEB.1.10.0906161104480.26093@gentwo.org>  <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>  <alpine.DEB.1.10.0906161522370.29941@gentwo.org>  <alpine.LFD.2.01.0906161231020.3282@localhost.localdomain>
 <1245215916.5604.5.camel@penberg-laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Pekka Enberg wrote:
> 
> So how does the page allocator fit in this new scheme of things? I have
> been looking at doing the cleanups you and Christoph suggested and it
> seems to me we need a 'system_gfp_mask' that's respected by basically
> everyone, including __might_sleep() and other debugging functions.

So I'm very much ok with the whole "use magic gfp_mask to indicate what 
works at what stage". And yes, I think it makes sense to extend it to the 
page allocator and might_sleep too, because GFP_KERNEL has all the same 
issues regardless of whether it's about page allocation or about slab 
allocators. And any "might_sleep" suppression really does tend to be about 
the exact same thing.

So the only thing I was arguing against wrt Christoph was really that I 
think this thing should be an "internal" thing, and never ever be used as 
a flag for others to decide what to do. We do _not_ want drivers or other 
crazy people using it to decide what state they are running in. 

Keep it simple, and keep it minimal, in other words.

		Linus
