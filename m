Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZDTA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZDTA5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZDTA5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:57:01 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:27724 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZDTA5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:57:00 -0400
X-IronPort-AV: E=Sophos;i="4.40,214,1238976000"; 
   d="scan'208";a="156387355"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
	<49EB9F59.4080904@zytor.com> <20090419223519.GA27706@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 19 Apr 2009 17:56:58 -0700
In-Reply-To: <20090419223519.GA27706@elte.hu> (Ingo Molnar's message of "Mon,
	20 Apr 2009 00:35:19 +0200")
Message-ID: <adaskk4ywf9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2009 00:56:59.0262 (UTC) FILETIME=[E8B7F9E0:01C9C152]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Also, atomicity might not be possible to guarantee on the bus level: 
 > say the device sits on a 32-bit PCI bus. (No matter what instruction 
 > the CPU gets, a readq/writeq there has to be done as two 32-bit bus 
 > accesses.)

Well, the conventional PCI devices I know of with 64-bit registers were
PCI-X cards, keyed so they would only fit into a 64-bit slot.  And of
course there is no such thing as 32-bit PCI Express.

 > (Also, even a genuine 64-bit device might be bridged over 32-bit 
 > pathways so a driver cannot really assume atomicity on that level.)

I have never even heard of a system with a 64-bit PCI slot that went
through a 32-bit pathway -- in fact I'm not sure how one could build
that.

But yes, for example on 32-bit PowerPC I don't think it's possible to
generate a 64-bit bus transaction in general.  So if a device requires
such a cycle then it simply can't work on such a system.  But there is
also the case where racing accesses to other registers must be avoided
(the mthca example I gave in my previous example) where the current
32-bit x86 definition is broken, but it could be fixed in a
driver-specific version that used a spinlock.

 - R.
