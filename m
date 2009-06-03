Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZFCIDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZFCIDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZFCICr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:02:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47736 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756797AbZFCICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:02:45 -0400
Date: Wed, 3 Jun 2009 08:59:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Merge Xen (the hypervisor) into Linux
Message-ID: <20090603085905.0d773cb7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090603010000.GE31976@mail.oracle.com>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
	<20090528001350.GD26820@elte.hu>
	<4A1F302E.8030501@goop.org>
	<20090528.210559.137121893.davem@davemloft.net>
	<4A1FCE8E.2060604@eu.citrix.com>
	<20090602224051.GB32428@goodmis.org>
	<20090602232843.GA6577@elte.hu>
	<20090603010000.GE31976@mail.oracle.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	The biggest reason I personally want Xen to be in mainline is
> PVM.  Dropping PVM is, to me, pretty much saying "let's merge Xen
> without taking the useful parts."

PVM is and has been for a long time a messaging parallel machine. Can you
not misuse the abbreviation in confusing ways (especially in email I read
in the morning ;))

Merging just hardware assisted vm support initially might be a perfectly
sensible path.

> 	Like Chris said, if we have technical hurdles for Xen to cross,
> let's get them out in the open and fixed.  If previous Xen developer
> interaction has left a bad taste in people's mouths, then the current
> crew has to make it up to us.  But we have to be willing to notice
> they're doing so.

Start by changing the mentality. Right now much of the patched code looks
like  "We made a decision years ago when creating Xen. Now we need to
force that code we wrote into Linux somehow".

Stuff gets merged a lot better if the thinking is "how do we make the
minimal changes to the existing kernel, cleanly and with minimal
inter-relationships". Only after that do you worry about whether
the existing in kernel interfaces are right.

There is a simple reason for this: Changing an interface in the kernel is
a consensus finding process around all visible users of the interface.
It's much easier to do that as a follow up. That way you can bench
alternatives, test if it harms any of the users and merge change sets
that span all the various users of the interface in one go.

It's also frequently the case that when you have a simple clean interface
that doesn't fit some in tree users it becomes blindly obvious what it
should look like.

So I would suggest the path is
- Use existing interfaces
- Merge chunks of the Xen code without worrying too much about performance
  in Xen but worry in detail about bare metal performance
- Don't worry about "hard" problems initially - eg with PAE just use the
  paravirt CPUID hook and deny having PAE to begin with
- Where there isn't a clean simple interface try as hard as possible to
  build some glue code using existing interfaces in the kernel

When it works, doesn't harm bare metal performance and is merged then go
back and worry about the harder stuff, optimisation and fine tuning. It
doesn't even need to be able to run all guests or all configurations
initially.

Also please can folks get out of the "how do we merge Xen" mentality into
the "How do we create dom0 functionality for Xen in Linux" - don't
pre-suppose the existing implementation is right.

Alan
