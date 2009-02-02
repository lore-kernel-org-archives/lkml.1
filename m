Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZBBXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZBBXA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbZBBXAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:00:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbZBBXAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:00:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Tue, 3 Feb 2009 00:00:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain> <1233614927.18767.121.camel@pasglop>
In-Reply-To: <1233614927.18767.121.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030000.18049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 14:05 -0800, Linus Torvalds wrote:
> > Well, I don't think anybody wants to (or necessarily has the ability) 
> > touch ACPI internals.
> > 
> Somebody has a rough idea of what underlying kernel support ACPI uses ?
> I know from discussions with Len that it's mostly mutexes... timers
> too ?

Please see my last message in this thread (just sent).

> It might end up being trivial to make it safe to call early with
> interrupts off with the trick you mentioned, since it's really just the
> same as boot as you mentioned.. ie, it's actually safe to take mutexes
> etc... since we -know- no other CPU is running and we aren't scheduling
> etc...

But we can't tell no one is holding the mutex in question, AFAICS.

I'm afraid we'd really need a special "no mutexes, no GFP_KERNEL allocations"
code path for that.

Thanks,
Rafael
