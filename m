Return-Path: <linux-kernel-owner+w=401wt.eu-S935500AbYCDXci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500AbYCDXci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935355AbYCDX1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:27:34 -0500
Received: from twin.jikos.cz ([213.151.79.26]:57183 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935384AbYCDX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:32 -0500
Date: Wed, 5 Mar 2008 00:25:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Roskin <proski@gnu.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only symbols
In-Reply-To: <20080304205117.GA21803@elte.hu>
Message-ID: <Pine.LNX.4.64.0803050023090.18589@twin.jikos.cz>
References: <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
 <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
 <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu>
 <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu>
 <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net> <20080304125744.GF29777@elte.hu>
 <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
 <20080304205117.GA21803@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Ingo Molnar wrote:

> > Ingo, i's simply not possible to put ndiswrapper in user-space sanely.
> > Drivers are drivers. They'll want (shared) interrupts, they want DMA, 
> > they want to do things like cli/sti.
> yeah, i agree that putting it into userspace is quite insane.
> it might possible to do it halfways sanely via existing arch/x86/kvm/ 
> infrastructure though. VMX/SVM context will properly emulate the IRQ 
> flag so cli/sti will work fine, and as long as DMA is properly 
> quarantined via an iommu it might even not corrupt the rest of the 
> system. 

This definitely could be a [hackish] way to go. The remarkable drawback 
is that it will not work on CPUs without virtualization extensions.

-- 
Jiri Kosina
SUSE Labs

