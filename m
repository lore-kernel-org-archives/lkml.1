Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZKRXTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZKRXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZKRXTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:19:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZKRXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:19:04 -0500
Message-ID: <4B0480C4.6080003@zytor.com>
Date: Wed, 18 Nov 2009 15:18:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [RFC PATCH 0/6] jump label v3
References: <cover.1258580048.git.jbaron@redhat.com>	<4B047A81.3060104@zytor.com> <20091118230758.0C49A9D5@magilla.sf.frob.com>
In-Reply-To: <20091118230758.0C49A9D5@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 03:07 PM, Roland McGrath wrote:
>> 67 66 8D 74 00 (lea si,[si+0]) should work as a 32-bit atomic NOP.  It's
>> not necessarily the fastest, though (I have no data on that.)
>> Similarly, 66 66 66 66 90 should also work.
> 
> We should get all the knowledge like that stored in places like the
> Kconfig.cpu comments near X86_P6_NOP and/or asm/nops.h macros and comments.
> 
> Let's have an ASM_ATOMIC_NOP5 macro in asm/nops.h?  I've lost track of the
> variants, and I'll leave that to you all who are close to the chip people.
> 
> I can't tell if it's the case that there will be kernel configurations
> where there is one known-safe choice but a different choice that's optimal
> if CPU model checks pass.  If so, we could compile in the safe choice and
> then mass-change to the optimal choice at boot time.  (i.e. like the
> alternatives support, but we don't really need to use that too since we
> already have another dedicated table of all the PC addresses to touch.)

Yes, I believe we do something like that already.
	
	-hpa
