Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZDVFfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZDVFfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZDVFfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:35:34 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:24528 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZDVFfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:35:33 -0400
X-IronPort-AV: E=Sophos;i="4.40,229,1238976000"; 
   d="scan'208";a="175035202"
Date: Tue, 21 Apr 2009 22:35:18 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jamie Lokier <jamie@shareable.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422053518.GA11055@cuplxvomd02.corp.sa.net>
References: <20090421165214.GB8251@cuplxvomd02.corp.sa.net> <Pine.LNX.4.44L0.0904211457150.3986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904211457150.3986-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By now, pretty much everone is probably up to speed on what the USB folks are
telling us:

	There is no way to avoid using some sort of timeout to decide
	whether the console is ever going to appear.

So:
1.	We want the minimum timeout possible so that headless systems will
	not be delayed any more than is necessary to detect that no console
	is available.
2.	As I understand it, USB devices don't generally come with any
	guarantee what the maximum time to initialize will be.

Therefore, as far as I can see, this means that we can't empirically
determine an appropriate timeout until we know what USB devices are
connected to a particular system. This, in turn, means that any default
timeout we might choose will have to have a command line parameter to
override it.

Naturally, we want to help a user determine as easily as possible just how
long it took to detect whatever serial device they may want to use so that
they can set the timeout so the system will boot as quickly as possible when
being used in a headless mode. This probably means picking a stable point
from which to start measuring the timeout, as well as printing how long it
took to detect the console, if there was one.

An open question is whether we want to wait for all possible consoles or
whether we can proceed with as few as one.

David VomLehn
