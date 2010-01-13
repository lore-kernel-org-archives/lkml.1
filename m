Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584Ab0AMWCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0AMWCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463Ab0AMWCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:02:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab0AMWCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:02:10 -0500
Message-ID: <4B4E427D.9090207@zytor.com>
Date: Wed, 13 Jan 2010 14:00:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>	<1263338274-6485-5-git-send-email-yinghai@kernel.org>	<1263340563.2854.1011.camel@sbs-t61.sc.intel.com>	<4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org>
In-Reply-To: <87tyupfzk8.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 01:46 PM, Andi Kleen wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>>
>> so you want to treat those disabled cpus in the those system as hotplug cpus or not?
> 
> Why not? It's not that a hotplug cpu is particularly expensive.
> It's just a bunch of memory and not even very much of it.
> 
> White and blacklists just to save a small amount of memory
> seem like a bad idea.
> 

There are configurations in which percpu memory is in the megabytes.
This is exactly why we need high water mark allocation of percpu memory:
for configurations where there are possible hotpluggable CPU sockets
(which may be virtual, and a lot larger number than necessary) we
shouldn't need to allocate memory for a processor which has never been
added and is net unlikely to ever be added.  The only alternative is to
go to great length to keep the
(percpu memory) x (possible cpus - actual cpus) product as small as
possible, which is shortchanging the utility of the percpu memory system.

	-hpa
