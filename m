Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYAYO5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYAYO5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYAYO5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:57:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbYAYO5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:57:37 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
From: Andi Kleen <andi@firstfloor.org>
References: <47993F1A.5070408@goop.org>
	<200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org>
	<200801250042.53074.yinghai.lu@sun.com>
	<20080125142150.GA27767@elte.hu>
Date: Fri, 25 Jan 2008 15:57:34 +0100
In-Reply-To: <20080125142150.GA27767@elte.hu> (Ingo Molnar's message of "Fri\, 25 Jan 2008 15\:21\:50 +0100")
Message-ID: <p73ir1i7y1t.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> what we should probably do instead is to have a filter function:
>
>    new_end = trim_range_to_mtrr_cached(start, end);
>
> and then we could iterate through every e820 map entry that is marked as 
> usable RAM, and send it through this filter. If the filter returns the 
> same value that got passed in, we keep the e820 entry unchanged. If the 
> filter returns a new "end" value, we use that in the e820 map.

To be fully generic you would need to allow it to adjust start too.

> that way, the current Tom2 hack is just a natural extension to the 
> filter function: it would (on AMD CPUs) recognize (within 
> trim_range_to_mtrr_cached filter) that all memory addresses above 4GB 
> are marked as cacheable via Tom2.
>
> Or something like this. Hm?

I agree that would be the correct way to do it.

Later on with PAT that filter could also do PAT related checks
and something like this will likely be needed anyways.

-Andi
