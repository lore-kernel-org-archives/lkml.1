Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYJIFxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYJIFxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYJIFw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:52:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYJIFw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:52:56 -0400
Message-ID: <48ED9BFB.4060904@redhat.com>
Date: Thu, 09 Oct 2008 01:51:55 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH] documentation: explain memory barriers
References: <20080911101616.GA24064@agk.fab.redhat.com>	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>	<20080923154905.50d4b0fa.akpm@linux-foundation.org>	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>	<20080923164623.ce82c1c2.akpm@linux-foundation.org>	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>	<20081001225404.4e973465.akpm@linux-foundation.org>	<20081008181223.6954c7b2.randy.dunlap@oracle.com>	<48ED5BC6.8040006@redhat.com> <20081008183125.2a24e3c2.akpm@linux-foundation.org>
In-Reply-To: <20081008183125.2a24e3c2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 08 Oct 2008 21:17:58 -0400 Chris Snook <csnook@redhat.com> wrote:
> 
>> Randy Dunlap wrote:
>>> On Wed, 1 Oct 2008 22:54:04 -0700 Andrew Morton wrote:
>>>
>>>> This sequence is repeated three or four times and should be pulled out
>>>> into a well-commented function.  That comment should explain the logic
>>>> behind the use of these barriers, please.
>>> and on 2008-OCT-08 Ben Hutchings wrote:
>>>
>>>> All memory barriers need a comment to explain why and what they're doing.
> 
> I approve this message.
> 
>> Seriously?  When a barrier is used, it's generally self-evident what 
>> it's doing.
> 
> fs/buffer.c:sync_buffer().  Have fun.

The real disaster there is the clear_buffer_##name macro and friends, as
evidenced by fs/ext2/inode.c:599

                clear_buffer_new(bh_result); /* What's this do? */

I'm completely in favor of documenting everything that can potentially interact
with that train wreck, but I maintain that the vast majority of memory barriers
are self-evident.

-- Chris
