Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbYFQVf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbYFQVf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbYFQVfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:35:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52238 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbYFQVfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:35:02 -0400
Message-ID: <48582E03.1040404@firstfloor.org>
Date: Tue, 17 Jun 2008 23:34:59 +0200
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
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <87od5zwzh2.fsf@basil.nowhere.org> <alpine.LFD.1.10.0806171412470.2907@woody.linux-foundation.org> <48582C18.4090900@firstfloor.org> <alpine.LFD.1.10.0806171429010.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806171429010.2907@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 17 Jun 2008, Andi Kleen wrote:
>> Loads are not supposed to fault in copy_to_user(). Only stores are.
> 
> Andi, just shut up already.
> 
> It is "copy_user". Notice the lack of "from" or "to". That code handles 
> *both* copy_to_user and copy_from_user.

Yes, but it assumes only one can fault at a time.

> 
>> If your patch fixes something then the main wrong thing is the caller
>> who passes a faulting source address.
> 
> Andi, SHUT THE F*CK UP. Read the code. Read the patch.

I did exactly the same patch first on your first email and then I realized
it was wrong before posting ;-)

> Sorry for ever 
> involving you. I don't want to hear your idiotic whining.

The patch is wrong because it'll break the other case (in this case
copy_from_user)

-Andi

