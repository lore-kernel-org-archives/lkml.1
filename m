Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbXLCNar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbXLCNar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXLCNak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:30:40 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48037
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbXLCNaj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:30:39 -0500
Message-Id: <4754132B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 03 Dec 2007 13:31:07 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>, <hch@lst.de>
Cc: <ananth@in.ibm.com>, <prasanna@in.ibm.com>,
       <anil.s.keshavamurthy@intel.com>, <ak@suse.de>,
       <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: x86: optimize page faults like all other achitectures and
	kill notifier cruft
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since I started to try to get at least some fundamental infrastructure
pieces merged for using NLKD on Linux I was told that direct calls out of
exception handlers for the sake of an individual (and perhaps even small)
sub-system is undesirable.

Making the exception notifiers report the right (correct) information (and,
specific to x86, ensuring they get called in the right place) was one of the
fundamental things, and just now I see that this is being reverted for (in
my eyes) no good reason: Instead of adding direct calls to x86, all the
other architectures should have followed the notifier model in order for
the infrastructure to be usable by external components, especially if
these aren't allowed into the kernel.

Am I to conclude that replacing direct calls elsewhere in the tree (in order
to e.g. avoid all kinds of small sub-components leaving their footprint in
core files like kernel/fork.c) is no longer a desirable goal, thereby making
it almost impossible to ever host a kernel debugger *without* having to
patch core files.

Thanks, Jan

