Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbYC0Mhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbYC0Mhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbYC0Mhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:37:40 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:40041 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYC0Mhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:37:39 -0400
Message-ID: <47EB950B.6030908@tiscali.nl>
Date: Thu, 27 Mar 2008 13:37:31 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dwalker@mvista.com, nickpiggin@yahoo.com.au
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] likeliness accounting cleanup
References: <47EAB608.6060204@tiscali.nl>
In-Reply-To: <47EAB608.6060204@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Store __builtin_return_address (caller) rather than __func__ in likeliness
> struct. 'line' and 'type' are combined in 'label'
> 
> +/- now denotes whether expectation fails in less than 5% of the tests - rather
> than whether more unexpected than expected were encountered. The function at
> the displayed filename & line and the caller are not necessarily the same.
> A few more Likely Profiling Results changes were made.
> 
> struct seq_operations becomes static, unsigned ints true and false (shadowed)
> are replaced by pos and neg.
> ---
> New layout:
> 
> Likely Profiling Results
>  --------------------------------------------------------------------
> [+- ]Type | # True  | # False | Function@Filename:Line
>  unlikely |        0|    32082| fget+0xd0/0x1d0@include/asm/arch/atomic_32.h:235
> 
> Compiles and runs here. Thanks for previous comments.
> 
>  include/linux/compiler.h |   16 ++++++++--------
>  lib/likely_prof.c        |   45 +++++++++++++++++++++++++--------------------
>  2 files changed, 33 insertions(+), 28 deletions(-)
> 

This should be applied after the -mm patches:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/profile-likely-unlikely-macros.patch
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/profile-likely-unlikely-macros-fix.patch

Also I forgot to add a signoff, so here it is:

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
