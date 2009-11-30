Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZK3S31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZK3S31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZK3S30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:29:26 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40970 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbZK3S30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:29:26 -0500
Date: Mon, 30 Nov 2009 10:29:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130182929.GD6762@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de> <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain> <20091130154031.GE21639@wotan.suse.de> <alpine.LFD.2.00.0911300754420.2872@localhost.localdomain> <20091130163923.GC6762@linux.vnet.ibm.com> <alpine.LFD.2.00.0911300852410.2872@localhost.localdomain> <20091130171333.GG21639@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130171333.GG21639@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 06:13:33PM +0100, Nick Piggin wrote:
> On Mon, Nov 30, 2009 at 09:05:57AM -0800, Linus Torvalds wrote:
> Secondly:
> 
> > 	static void tasklist_read_lock(void)
> > 	{
> > 		preempt_disable();
> > 		if (!current->tasklist_count++)
> 
> What happens if an interrupt and nested tasklist_read_lock() happens
> here?

Ouch!!!  This race affects the reader-writer-lock version as well.
Ah well, looks like interrupt disabling is required either way.

							Thanx, Paul
