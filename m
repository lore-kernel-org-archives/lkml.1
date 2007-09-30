Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXI3US3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXI3US3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXI3USW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:18:22 -0400
Received: from smtp.cce.hp.com ([161.114.21.22]:12987 "EHLO
	ccerelrim01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXI3USU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:18:20 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 30 Sep 2007 16:18:06 -0400
User-Agent: KMail/1.9.7
Cc: Theodore Tso <tytso@mit.edu>, Joshua Brindle <method@manicmethod.com>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
References: <46FEEBD4.5050401@schaufler-ca.com> <200709301939.57542.ak@suse.de> <20070930190742.GB9358@thunk.org>
In-Reply-To: <20070930190742.GB9358@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709301618.07775.paul.moore@hp.com>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.9.30.125322
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007 3:07:42 pm Theodore Tso wrote:
> There are different kinds of security.  Not all of them involve
> cryptography and IPSEC.  Some of them involve armed soldiers and air
> gap firewalls.  :-)
>
> Yes, normally the network is outside the Trusted Computing Base (TCB),
> but a cluster of Linux machines in a rack is roughly the same size of
> a huge Unix server tens year ago --- and it's not like Ethernet is any
> more secure than the PCI bus.  So why do we consider communications
> across a PCI bus secure even though they aren't encrypted?  Why,
> because normally we assume the PCI bus is inside the trust boundary,
> and so we don't worry about bad guys tapping communications between
> the CPU and the hard drive on the PCI bus.
>
> But these days, it is obviously possible to create clusters where
> certain network interfaces are only connected to machines contained
> completely inside the trust boundary, just like a PCI bus in a
> traditional server.  So don't be so quick to dismiss something like
> CIPSO out of hand, just because it doesn't use IPSEC.

Sorry I'm a bit late to the discussion (been busy doing "weekend" things), but 
I see that Casey, Josh, and Ted have already given a pretty good explanation 
of why CIPSO is not as "evil" as it appears at first glance.  I won't restate 
the points they have already made, but I think there are two other points 
worth mentioning:

The first is that CIPSO options are immutable, which means they work 
wonderfully with IPsec.  Label integrity can be provided through the use of 
AH and/or tunneled ESP, label confidentiality can be provided through 
tunneled ESP.  While the SELinux specific labeled IPsec implementation we 
currently have in the kernel is nice if you are talking to other SELinux 
machines, it has a very real handicap in that you can't use it to talk 
anything else.  CIPSO, or CIPSO in combination with standard, non-labeled 
IPsec, can be used to talk to pretty much any trusted OSs out there.  
Adherence to standards and interoperability with other OSs have always been a 
key factor of Linux's acceptance into new areas; support for CIPSO is just 
another part of this drive for greater interoperability.

The second point I wanted to make is that in the course of putting together 
the CIPSO implementation in the kernel I ended up talking with a few people 
who were involved in the original TSIG effort and the mess with the IETF.  
>From what I could gather, the main technical complaint (other than a variety 
of political complaints which aren't relevant to our discussion here) was 
that CIPSO options are difficult to parse (they are, look at the format - 
it's an option within an option format - yuck) and the intermediate node 
vendors did not like it all (too much work to do in a fastpath ASIC).  After 
all, look at the [R]IPSO RFC, dated only eight months earlier, and there is 
no cryptographic "special sauce" in that protocol.

CIPSO isn't for everyone, I'll be the first to admit that.  However, if you 
look at the mailing list archive for the Linux LSPP effort, the SELinux list, 
and to a lesser extent the netdev and LSM lists you will see that there are a 
set of users who care very much about this functionality.  Our support of 
CIPSO is helping Linux operate in areas it wouldn't be able to elsewhere and 
I consider that a "win".

-- 
paul moore
linux security @ hp
