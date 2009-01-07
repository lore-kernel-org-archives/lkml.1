Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbZAGVmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbZAGVmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZAGVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:42:31 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:58673 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762083AbZAGVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:42:30 -0500
Date: Thu, 8 Jan 2009 00:42:28 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: =?utf-8?B?UsOpbWk=?= Denis-Courmont <rdenis@simphalempin.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Message-ID: <20090107214228.GA4610@ioremap.net>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901071852.32078.rdenis@simphalempin.com> <20090107174809.GA8989@ioremap.net> <200901072254.14017.rdenis@simphalempin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901072254.14017.rdenis@simphalempin.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 10:54:13PM +0200, Rémi Denis-Courmont (rdenis@simphalempin.com) wrote:
> No no no.
> 
> There is a huge fundamental difference between setrlimit, prctl(SECCOMP), 
> set*uid and chroot on the one side, and iptables on the other side: The first 
> ones are APIs for a process to control its own permission. iptables is an 
> interface to control the _whole_ system.
> 
> In other words, the first ones are usable programmatically. iptables is not, 
> unless you're willing to assume the kernel only operates one single 
> userland "software".

iptables 'owner' match module exactly 'operates one signel userland software'.

> From the perspective of distros and system admins, perhaps SELinux and 
> iptables are sufficient to address this. But from that of a third-party, 
> upstream, distro-independent or whatever-you-want-to-call-it software vendor, 
> they don't quite work due to their centralized nature.

Actually selinux is even better example although this does depend on the
distro. System which wants to secure network connections already knows
what is the netfilter. This dependency equals to the recent-enough
kernel with the new rlimit.

To be clear: I do _not_ object against this patch. This is likely a good
idea and while it potentially can be implemented via different way, it
has its right for the existance :)

> > > As I understand it, Michael is trying to build something similar to
> > > SECCOMP,  only way less restrictive and way more usable by real-life
> > > userland programs. 
> 
> > Security and unpriveledged setup are mutually impossible cases.
> 
> On a high-level, sure. You need a trusted privileged entity somewhere.
> 
> But when it comes _specifically_ to "unprivileged" as in "non-root", I believe 
> there is a use case for something less restrictive than SECCOMP, yet more 
> restrictive than just being a normal non-root process. Something along the 
> lines of: cannot debug other processes, cannot send signal to them, cannot 
> create file descriptors, cannot bind sockets, yet can allocate memory, can 
> read timers, can read/write from any type of (already opened) file. Or 
> whatever brighter and more knowledgeable mind than mine could define.
> 
> Or can someone prove that there is no set of permissions bigger than those of 
> SECCOMP that would effectively equate to those of a normal non-privileged 
> process?

We have a good capabilities subsystem and it has proper layered design.
But still rlimit has to be assigned by something higher in this
hierarchy.

-- 
	Evgeniy Polyakov
