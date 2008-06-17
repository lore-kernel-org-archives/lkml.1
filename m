Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYFQVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYFQVPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbYFQVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:15:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33352 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbYFQVPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:15:13 -0400
Message-ID: <4858295D.8000904@firstfloor.org>
Date: Tue, 17 Jun 2008 23:15:09 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386, bisected,
 reproducable)
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 17 Jun 2008, Linus Torvalds wrote:
>> I actually am starting to think that the bug is in 
>> __copy_to_user_inatomic_nocache().
> 
> Confirmed.
> 
> The uncached user copies are totally broken. The number of bytes left 
> uncopied is simply wrong, because of how it does that unrolled loop and 
> doesn't account for the fact that just doing loads does not actually 
> increase the number of bytes copied at all.

How can a load fault legitimately in copy_to_user?

-Andi


