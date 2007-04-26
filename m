Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbXDZIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbXDZIHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbXDZIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:07:17 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:57495 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S933638AbXDZIHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:07:14 -0400
Date: Thu, 26 Apr 2007 00:27:37 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Olivier Galibert <galibert@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Christian Hesse <mail@earthworm.de>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <1177552619.5025.147.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.63.0704260016590.9337@qynat.qvtvafvgr.pbz>
References: <20070419070437.GA25211@elte.hu>  <20070424202336.GC16503@elf.ucw.cz>
  <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> 
 <20070424212408.GD16457@elf.ucw.cz>  <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
  <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> 
 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> 
 <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org> 
 <20070425233355.GA36476@dspnet.fr.eu.org> <1177552619.5025.147.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nigel Cunningham wrote:

> Hi.
>
> On Thu, 2007-04-26 at 01:33 +0200, Olivier Galibert wrote:
>> On Wed, Apr 25, 2007 at 11:50:45AM -0700, Linus Torvalds wrote:
>>> .. but if the alternative is a feature that just isn't worth it, and
>>> likely to not only have its own bugs, but cause bugs elsewhere? (And yes,
>>> I believe STD is both of those. There's a reason it's called "STD". Go
>>> to google and type "STD" and press "I'm feeling lucky". Google is God).
>>
>> If it was correctly designed, it would be possible to change the
>> hardware or even the kernel through a STD cycle.  And that would be
>> damn interesting on servers.
>
> Those are different issues - hardware hot/cold plugging for the first.
>
> Changing the kernel through a cycle - that's not a design fault. The
> problem there is that the kernel and it's associated data structures are
> part of the state. Changing the kernel and keeping the image would
> require exactly correspondence in data structures, memory map and so on.
> That's why the same kernel is required.

that depends on exactly what you save in your snapshot.

one approach is to try and save absolutly everything in ram (this is the current 
approach)

if you do this then you do need to use the same kernel for the reasons that you 
list.

however, you could also decide to only save the information about processes on 
the system (i.e. what you absolutly have to) and let the kernel re-initialize 
itself (along with it's devices) then you could use a different kernel safely. 
doing this should also save you a significant amount of storage when makeing 
your snapshot

David Lang

