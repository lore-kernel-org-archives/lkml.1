Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZDUQyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZDUQyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZDUQwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:52:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19766 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbZDUQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:52:28 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="290188159"
Date: Tue, 21 Apr 2009 09:52:14 -0700
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
Message-ID: <20090421165214.GB8251@cuplxvomd02.corp.sa.net>
References: <20090421140533.GA6375@shareable.org> <Pine.LNX.4.44L0.0904211026080.2981-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904211026080.2981-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If somebody would like to suggest a programming interface (a waitqueue 
> perhaps?) by which the USB hub driver could send a notification when it 
> becomes idle, I could implement it.

I actually started the USB console stuff with exactly this approach, but
switched to the approach that's out there. A minor drawback, which is
probably obvious, is that you actually wait for some interval without
getting anything to do before you think things are idle.  But a bigger
drawback is that you lose the ability to chose appropriate intervals for
different classes of devices.

So far, there appear to be three possible USB boot devices: consoles, network
devices, and boot devices. A system may not have all of these and so may not
need to wait as long as a system with all of them. One of my goals is to
preserve as much of the reduction in boot time as possible, even on systems
that use USB devices that may or may not be plugged in.

> Alan Stern

David VomLehn
