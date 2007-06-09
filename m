Return-Path: <linux-kernel-owner+w=401wt.eu-S970682AbXFIBmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970682AbXFIBmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969432AbXFIBmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:42:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60186 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969249AbXFIBmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:42:15 -0400
Date: Sat, 9 Jun 2007 02:41:40 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609014140.GC4095@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466A0020.50406@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 06:19:28PM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Al Viro wrote:
> > Exactly.  Put it another way, randomizer is a stress-tester.
> 
> ... and a security mechanism.  And as such it is only useful if it is
> used.  Probably it should be policy-controlled whether you can turn it off.
 
Any real-world examples of exploitable holes based on that?  Real blue-sky
world, not grsec-advocacy "undiscovered null ptr derefs on every corner and
all of the variety fixable by our magic goo" one, please.

> > Note that
> > #define NR_FILES <some constant>
> > 
> > for (i = 0; i < NR_FILES; i++)
> > 	close(i);
> 
> You're confusing the problems.

No, I'm not.  The entire argument for having a separate set of descriptors
is based on programs behaving in similar fashion, working correctly now but
limiting what libraries can do with opening files for internal needs.

So here's the question: how widespread it really is, considering that "working
correctly" is not a trivial constraint.  Again, I'd love to see real data;
if I need handwaving, I know where to find it.
