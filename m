Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZGAGy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZGAGy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZGAGyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:54:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26747 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZGAGyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:54:18 -0400
Message-Id: <4A4B24280200007800008618@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 01 Jul 2009 07:54:00 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] replace various uses of num_physpages by
	 totalram_pages
References: <4A4A0E50020000780000830B@vpn.id2.novell.com>
 <200907011427.52943.rusty@rustcorp.com.au>
In-Reply-To: <200907011427.52943.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Rusty Russell <rusty@rustcorp.com.au> 01.07.09 06:57 >>>
>On Tue, 30 Jun 2009 08:38:32 pm Jan Beulich wrote:
>> Sizing of memory allocations shouldn't depend on the number of physical
>> pages found in a system, as that generally include (perhaps a huge
>> amount of) non-RAM pages. The amount of what actually is usable as
>> storage should instead be used as a basis here.
>
>I like this patch.  Where's num_physpages used after this: should it be an 
>arch-specific or even a static?

It's still being used for some hash value initialization in under net/, and in
the generic power management code (kernel/power/). While the earlier
part certainly looks replaceable, I'm not certain about the latter.

In any case it would seem like a first step might now be to no longer export
the symbol (or, for a transitional period, make it an unused export).

Once all uses are gone, making it arch specific (reducing its scope as much
as possible, up to complete elimination) would certainly seem desirable
(not the least to perhaps finally address comments like "How many end-
of-memory variables you have, grandma!").

Jan

