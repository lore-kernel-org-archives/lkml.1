Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbYBUSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbYBUSgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYBUSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:36:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYBUSgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:36:08 -0500
Message-ID: <47BDC43F.4070106@zytor.com>
Date: Thu, 21 Feb 2008 10:34:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
 section into init BSS section
References: <1203581723.4707.20.camel@caritas-dev.intel.com> <20080221090557.GB20055@elte.hu> <1203586106.4707.25.camel@caritas-dev.intel.com> <20080221095301.GA29361@elte.hu>
In-Reply-To: <20080221095301.GA29361@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> well, that's bad. We'd silently ignore the " = 1" and boot up with that 
> value at 0, right? At minimum we need some really prominent build-time 
> _errors_ (i.e. aborted builds) if this ever happens. But ideally, 
> shouldnt this whole thing be done at link time? Couldnt the linker sort 
> the variables that are zero initialized into the right section, and move 
> this constant maintenance pressure off the programmer's shoulder?
> 

Not the linker (unless each variable is put in its own section)... the 
compiler could (should!) do it... unfortunately gcc failed to provide a 
way to specify rodata, data and bss sections for a single data item (on 
the assumption that if you specified a section, you already knew were it 
should be going.)

What we really need is a new gcc extension:

__attribute__((sections("data", "rodata", "bss")))

... where gcc stuffs it into the appropriate section depending on where 
it belongs, just as it does with undecorated data items.

	-hpa
