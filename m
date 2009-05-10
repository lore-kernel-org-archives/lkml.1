Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZEJGoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZEJGoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZEJGn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:43:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZEJGn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:43:58 -0400
Message-ID: <4A06778E.9030908@zytor.com>
Date: Sat, 09 May 2009 23:43:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com> <4A03F016.76EA.0078.0@novell.com> <874ovvo0wo.fsf@basil.nowhere.org> <4A0492EA.6080403@zytor.com> <20090508205347.GC23223@one.firstfloor.org> <4A049B99.4000402@zytor.com> <20090509100008.GD23223@one.firstfloor.org>
In-Reply-To: <20090509100008.GD23223@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> However, as far as querying SRAT, I don't like the idea of spreading the 
>> knowledge of the system memory map out between a bunch of different 
>> places, each of which have a little piece of the puzzle.  It puts a huge 
>> onus on the user to know what mechanisms are actually available, and 
>> really makes a shitty interface.
> 
> AFAIK another popular OS always combines mappings from all sources (e820,
> SRAT, PCI, PNP, ACPI etc.) in the query before allocating anything.
> Something like that might be a reasonable long term direction for Linux
> too, but it's probably also a can of worms to handle the conflicts
> between the various sources (e.g. e820 reserves a lot of things
> in other sources too). It would be a rather large change.
> Maybe that would handle the systems I thought of above.

You *always* have a conflict resolution policy... whether or not it is
explicit or accidental, and whether or not it is the result of merging
the data or just accessing multiple data sources is another matter.  It
might be hard to replicate an accidental policy in an explicit way, or
the accidental policy really might make no sense, which may mean
behavior changes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

