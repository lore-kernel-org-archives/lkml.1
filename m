Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbYFFBkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbYFFBkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 21:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYFFBkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 21:40:31 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:50478 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYFFBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 21:40:30 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
From: Andi Kleen <andi@firstfloor.org>
References: <4848046A.5060006@goop.org>
Date: Fri, 06 Jun 2008 03:40:24 +0200
In-Reply-To: <4848046A.5060006@goop.org> (Jeremy Fitzhardinge's message of "Thu, 05 Jun 2008 16:21:14 +0100")
Message-ID: <87ve0ntk6v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jun 2008 01:33:16.0160 (UTC) FILETIME=[4AE3C000:01C8C775]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> The 46-bit mask used in 64-bit seems pretty arbitrary. 

The rationale for the 46 bits is that the kernel needs roughly 4x as 
much virtual space as physical space and the virtual space is limited
to 48bits.

To be exact 47 bits is always user space and the 47 bits remaining
for the kernel are split into half, with one half for the direct mapping
and the other half for random mappings.  With some pushing you could
extend it to 46.5 bits or so, but beyond that you'll be in trouble.

It's not arbitrary at all.

-Andi

