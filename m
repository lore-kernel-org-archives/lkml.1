Return-Path: <linux-kernel-owner+w=401wt.eu-S965393AbXBFTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393AbXBFTpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965394AbXBFTpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:45:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34611 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965393AbXBFTpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:45:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, discuss@x86-64.org,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       "Richard Gooch" <rgooch@safe-mbox.com>
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
References: <20070205171959.GF8665@alberich.amd.com>
	<m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
	<20070206160828.GH8665@alberich.amd.com>
	<m1sldjtbn4.fsf@ebiederm.dsl.xmission.com>
	<20070206184213.GA4628@alberich.amd.com>
	<m1zm7rrtnn.fsf@ebiederm.dsl.xmission.com>
	<20070206192533.GB5647@amd.com>
Date: Tue, 06 Feb 2007 12:44:35 -0700
In-Reply-To: <20070206192533.GB5647@amd.com> (Joerg Roedel's message of "Tue,
	6 Feb 2007 20:25:33 +0100")
Message-ID: <m1odo7rrz0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Joerg Roedel" <joerg.roedel@amd.com> writes:

> On Tue, Feb 06, 2007 at 12:08:12PM -0700, ebiederm@xmission.com wrote:
>> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
>> > You are referring to current Linux implementation?
>> > The AMD64 architecture increased physical address size in PSE mode to
>> > 40 bits. So at least it would be possible to use more than 32 bits.
>> 
>> How do you get 40 physical bits in a 32bit page table entry? My memory
>> is that the low bits in the page table entry were well defined and
>> accounted for. I'm pretty certain I can account for 6 of the low bits
>> off the top of my head.  PSE is the page size extension allowing pages 2MB/4MB
>> pages.
>
> The access to 40 physical address bits is only possible using large pages
> (4MB on 32bit without PAE). In those page tables entrys you only use
> bits 22:31 for encoding the physical address. The bits 12:21 are
> unused. These unused bits are reused to encode bits 32:39 of the 40 bit
> physical address.

Yep.  I missed that feature, and I do see it in AMD documentation now
that I look.

I'm not certain what that would be useful for though.

I'm pretty certain doesn't use this feature, we just enable PAE mode.

Eric
