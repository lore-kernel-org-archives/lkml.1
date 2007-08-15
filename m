Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbXHORko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbXHORko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765759AbXHORkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:40:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760750AbXHORkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:40:35 -0400
Message-ID: <46C33A67.1020102@redhat.com>
Date: Wed, 15 Aug 2007 13:39:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [RESEND] PIE executable randomization
References: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz> <20070814200647.GN2063@devserv.devel.redhat.com> <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 04:41 PM, Jiri Kosina wrote:
> (added Arjan to CC, as he has been working on the kernel part of the 
> randomization previously)
> 
> On Tue, 14 Aug 2007, Jakub Jelinek wrote:
> 
>> If I'm reading the above hunk correctly, this means we will randomize 
>> all PIEs and even all dynamic linkers invoked as executables on i?86 and 
>> x86_64, and on the rest of arches we won't randomize at all, instead 
>> load ET_DYN objects at ELF_ET_DYN_BASE address. But I don't see anything 
>> i?86/x86_64 specific on this.
> 
> Hi Jakub,
> 
> actually, it is currently arch-specific, and that's because of different 
> memory layouts on different archs.
> 
> It turned out recently that PIE-compiled binaries on x86_64, that perform 
> larger amount of brk-allocations (for example bash) will not work (but 
> they will work on ?86). This is because currently on ?86 the memory layout 
> is as follows:

But your patch is enabling randomization for x86_64, because CONFIG_X86
includes both 32 and 64 bit archs.

