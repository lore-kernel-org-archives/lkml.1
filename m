Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYDRKgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYDRKgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYDRKfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:35:54 -0400
Received: from namei.org ([69.55.235.186]:55698 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750778AbYDRKfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:35:52 -0400
Date: Fri, 18 Apr 2008 20:32:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>
Subject: Re: 2.6.25-mm1: not looking good
In-Reply-To: <20080418072457.GB18044@elte.hu>
Message-ID: <Xine.LNX.4.64.0804182029110.5998@us.intercode.com.au>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
 <84144f020804172340l79f9c815u42e4dad69dada299@mail.gmail.com>
 <20080418072457.GB18044@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Ingo Molnar wrote:

> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Andrew, you don't seem to have slab debugging enabled:
> > 
> > # CONFIG_DEBUG_SLAB is not set
> > 
> > And quite frankly, the oops looks unlikely to be a slab bug but rather 
> > a plain old slab corruption cause by the callers...
> 
> hm, there's sel_netnode_free() in the stackframe - that's from 
> security/selinux/netnode.c. Andrew, any recent changes in that area?

I've reverted the -mm only change to that file in 

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


commit f777964ad75cf4a119d911d12e81948d2402677f
Author: James Morris <jmorris@namei.org>
Date:   Fri Apr 18 20:27:24 2008 +1000

    Revert "SELinux: Made netnode cache adds faster"
    
    This reverts commit 6bf8f41d4efdf9d4eeb4f7df9c591e281f7da93e.
    
    Possible cause of slab corruption in -mm.



-- 
James Morris
<jmorris@namei.org>
