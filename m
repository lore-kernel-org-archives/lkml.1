Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYGRJLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYGRJLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYGRJLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:11:32 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:32467 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYGRJLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:11:31 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
From: Andi Kleen <andi@firstfloor.org>
References: <1216146802.3312.95.camel@localhost.localdomain>
Date: Fri, 18 Jul 2008 11:11:07 +0200
In-Reply-To: <1216146802.3312.95.camel@localhost.localdomain> (James Bottomley's message of "Tue, 15 Jul 2008 13:33:22 -0500")
Message-ID: <87ej5rsgk4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2008 09:11:05.0564 (UTC) FILETIME=[3547A9C0:01C8E8B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> One of the big nasties of systemtap is the way it tries to embed
> virtually the entirety of the kernel symbol table in the probe modules
> it constructs.  This is highly undesirable because it represents a
> subversion of the kernel API to gain access to unexported symbols.  At
> least for kprobes, the correct way to do this is to specify the probe
> point by symbol and offset.
>
> This patch converts systemtap to use the correct kprobe
> symbol_name/offset pair to identify the probe location.
>
> This only represents a baby step:  after this is done, there are at
> least three other consumers of the systemtap module relocation
> machinery:
>
>      1. unwind information.  I think the consumers of this can be
>         converted to use the arch specific unwinders that already exist
>         within the kernel


Right now x86 doesn't really have a good reliable unwinder that
works without frame pointer. I think systemtap
recently switched to Jan Beulich's dwarf2 unwinder. Before
switching to the in kernel unwinder that one would need to be 
re-merged again.

-Andi

