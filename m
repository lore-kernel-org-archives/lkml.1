Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbXI3TIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbXI3TIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXI3THv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:07:51 -0400
Received: from thunk.org ([69.25.196.29]:33354 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXI3THt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:07:49 -0400
Date: Sun, 30 Sep 2007 15:07:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <ak@suse.de>
Cc: Joshua Brindle <method@manicmethod.com>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070930190742.GB9358@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Andi Kleen <ak@suse.de>,
	Joshua Brindle <method@manicmethod.com>,
	Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
	torvalds@linux-foundation.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <200709301042.26473.ak@suse.de> <46FFDCEF.20404@manicmethod.com> <200709301939.57542.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709301939.57542.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 07:39:57PM +0200, Andi Kleen wrote:
> > CIPSO also lets systems like SELinux and SMACK talk to other trusted 
> > systems (eg., trusted solaris) in a way they understand. 
> 
> Perhaps, but is the result secure? I have severe doubts.

As always, it depends on your environment.  There are people who are
using Linux systems where trusting the network makes sense.  For
example, if you're on a battleship, say, or all of the machines are in
a cluster which is inside a Tempest-shielded machine room with a
massive combination lock that you might find on a bank vault, or if
you're environment where network cables are protected by pressurized
pipes (so any attempt to tamper with or tap the cables causes a
pressure drop which sets off the alarm which summons the Marines armed
with M-16's...).

(I've been inside classified machine rooms, which is why my laptop has
the 'Unclassified' label on it; it's needed so people can easily
eyeball it and know that I'm not allowed to connect it to any of the
classified networks.  And those are just the less serious machine
rooms.  In the really serious classified areas with the bank
vault-like doors, and the copper-tinted windows, I'm not allowed to
bring in an unclassified laptop at all --- and yes, Linux is being
used in such environments.  And yes, they do sometimes use IPSO and/or
CIPSO.)

> Security that isn't secure is not really useful. You might as well not
> bother.

There are different kinds of security.  Not all of them involve
cryptography and IPSEC.  Some of them involve armed soldiers and air
gap firewalls.  :-)

Yes, normally the network is outside the Trusted Computing Base (TCB),
but a cluster of Linux machines in a rack is roughly the same size of
a huge Unix server tens year ago --- and it's not like Ethernet is any
more secure than the PCI bus.  So why do we consider communications
across a PCI bus secure even though they aren't encrypted?  Why,
because normally we assume the PCI bus is inside the trust boundary,
and so we don't worry about bad guys tapping communications between
the CPU and the hard drive on the PCI bus.

But these days, it is obviously possible to create clusters where
certain network interfaces are only connected to machines contained
completely inside the trust boundary, just like a PCI bus in a
traditional server.  So don't be so quick to dismiss something like
CIPSO out of hand, just because it doesn't use IPSEC.

Regards,

	   	   		      	       - Ted
