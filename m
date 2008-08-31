Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYHaSG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYHaSG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbYHaSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:06:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756197AbYHaSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:06:40 -0400
Date: Sun, 31 Aug 2008 11:03:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808311054q4b8e8921qa9f090527b456e34@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808311100520.12958@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808302334.29156.rjw@sisk.pl>  <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com>  <200808311427.19369.rjw@sisk.pl>  <alpine.LFD.1.10.0808311039330.12958@nehalem.linux-foundation.org>
 <86802c440808311054q4b8e8921qa9f090527b456e34@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Aug 2008, Yinghai Lu wrote:
> 
> wonder how the probe could find out the size of is 1fff_ffff..

Heh. That's how PCI sizing works: you write all ones to the register, and 
read back the result. The low bits won't change, and that indicates the 
size.

But if _none_ of the bits change, then that simply means that the size 
will be calculated to be 0xffffffff-start.

So the sizing will "work", it will just always report that the BAR covers 
everything from start to the 4G limit.

		Linus
