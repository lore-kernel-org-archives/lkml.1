Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbZAGUx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbZAGUx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZAGUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:53:44 -0500
Received: from yop.chewa.net ([91.121.105.214]:55649 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbZAGUxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:53:44 -0500
From: =?utf-8?q?R=C3=A9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Organization: Remlab.net
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Date: Wed, 7 Jan 2009 22:54:13 +0200
User-Agent: KMail/1.9.9
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901071852.32078.rdenis@simphalempin.com> <20090107174809.GA8989@ioremap.net>
In-Reply-To: <20090107174809.GA8989@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901072254.14017.rdenis@simphalempin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 7 janvier 2009 19:48:09 Evgeniy Polyakov, vous avez écrit :
> If setting that rlimit does not require admin priviledges, then it does
> not require to drop this. So it is superuser or admin who does this.
> And exactly the same can be achieved with 'owner' iptables module.

No no no.

There is a huge fundamental difference between setrlimit, prctl(SECCOMP), 
set*uid and chroot on the one side, and iptables on the other side: The first 
ones are APIs for a process to control its own permission. iptables is an 
interface to control the _whole_ system.

In other words, the first ones are usable programmatically. iptables is not, 
unless you're willing to assume the kernel only operates one single 
userland "software".

>From the perspective of distros and system admins, perhaps SELinux and 
iptables are sufficient to address this. But from that of a third-party, 
upstream, distro-independent or whatever-you-want-to-call-it software vendor, 
they don't quite work due to their centralized nature.

> > As I understand it, Michael is trying to build something similar to
> > SECCOMP,  only way less restrictive and way more usable by real-life
> > userland programs. 

> Security and unpriveledged setup are mutually impossible cases.

On a high-level, sure. You need a trusted privileged entity somewhere.

But when it comes _specifically_ to "unprivileged" as in "non-root", I believe 
there is a use case for something less restrictive than SECCOMP, yet more 
restrictive than just being a normal non-root process. Something along the 
lines of: cannot debug other processes, cannot send signal to them, cannot 
create file descriptors, cannot bind sockets, yet can allocate memory, can 
read timers, can read/write from any type of (already opened) file. Or 
whatever brighter and more knowledgeable mind than mine could define.

Or can someone prove that there is no set of permissions bigger than those of 
SECCOMP that would effectively equate to those of a normal non-privileged 
process?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
