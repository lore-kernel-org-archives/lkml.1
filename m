Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYJaQrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYJaQrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYJaQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:46:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbYJaQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:46:58 -0400
Date: Fri, 31 Oct 2008 09:46:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <86802c440810310935w2f739679s9deaf28f6d9e64c9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810310944260.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>  <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net>  <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>  <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org> 
 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>  <20081031100040.1f0cf34f@bike.lwn.net>  <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <86802c440810310935w2f739679s9deaf28f6d9e64c9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Oct 2008, Yinghai Lu wrote:
> 
> then we don't need e820_reserve_resources_late, right?

Wrong.

Think about exactly the broken case: a buggy e820 BIOS sets the e820 map 
resource listing so that it *straddles* a real physical resource.

The fact is, the "late" part isn't because of IORESOURCE_BUSY. It's 
because FIRMWARE IS INEVITABLY A STINKING PILE OF BUGGY SH*T THAT MUST 
NOT BE ALLOWED TO SCREW UP DEVICE DISCOVERY.

Sorry for shouting, but people really need to understand this.

			Linus
