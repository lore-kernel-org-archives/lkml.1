Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZGUDtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZGUDtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZGUDto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:49:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:33778 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbZGUDto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:49:44 -0400
Date: Tue, 21 Jul 2009 13:45:31 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>,
       spender@grsecurity.net, Daniel J Walsh <dwalsh@redhat.com>,
       cl@linux-foundation.org, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, kees@outflux.net
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
In-Reply-To: <1248132223.2654.278.camel@localhost>
Message-ID: <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org>
References: <1248132223.2654.278.camel@localhost>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Eric Paris wrote:

> Does anyone see a better way to let users continue to be users while
> protecting most people?  Yes SELinux is stronger in some areas than
> without confining the ability to map the 0 page, but as has be rightly
> pointed out it's foolish an broken that SELinux can weaken any
> protections.

I haven't seen a better idea so far.

I strongly believe that we need to maintain the principle, in SELinux and 
LSM generally, that the interface is restrictive, i.e. that it can only 
further restrict access.  It should be impossible, from a design point of 
view at least, for any LSM module to authorize more privilege than 
standard DAC.  This has always been a specific design goal of LSM.  (The 
capability module is an exception, as it has a fixed security policy and 
implements legacy DAC behavior; there's no way to "fix" this).

In this case, we're not dealing with a standard form of access control, 
where access to a userland object is being mediated.  We're trying to 
mediate the ability of a subject to bypass a separate mechanism which aims 
to protect the kernel itself from attack via a more fundamental system 
flaw.  The LSM module didn't create that vulnerability directly, but it 
must not allow the vulnerability to be more easily exploited.

The security policy writer should have a guarantee that the worst mistake 
they can make is to mess up their own security model; if they can mess up 
the base DAC security with MAC policy, we break that guarantee.  There's 
also an issue of user confidence in the LSM modules, in that they should 
not be any worse off security-wise if they enable an enhanced protection 
mechanism.

This does not account for kernel bugs in the LSM modules themselves, 
obviously, but the same can be said for any kernel code, albeit with less 
irony.


- James
-- 
James Morris
<jmorris@namei.org>
