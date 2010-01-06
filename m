Return-Path: <linux-kernel-owner+w=401wt.eu-S932886Ab0AFVnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab0AFVnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300Ab0AFVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:43:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293Ab0AFVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:43:14 -0500
Date: Wed, 6 Jan 2010 13:42:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] log2.h: Macro-ize is_power_of_2() for use in
 BUILD_BUG_ON
Message-Id: <20100106134232.0025e818.akpm@linux-foundation.org>
In-Reply-To: <aday6kbt14a.fsf@roland-alpha.cisco.com>
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	<20100106123306.ac85e557.akpm@linux-foundation.org>
	<aday6kbt14a.fsf@roland-alpha.cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 12:44:05 -0800
Roland Dreier <rdreier@cisco.com> wrote:

> 
>  > Perhaps we can avoid worrying about that via
> 
>  > #define BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
>  > 	BUILD_BUG_ON((n != 0 && ((n & (n - 1)) == 0)))
> 
> Having something so specific to this particular case makes me feel like
> maybe it's just not worth it.

mm..  I think _something_ is worth it.  The requirement that a constant
be a power of two is a very common one in the kernel.

If you feel strongly about it and think the incremental benefit of your
version is worth the effort of screening out gcc warts then ho hum, go
for it I guess.

>  At least in the case I'm looking at, we
> could just have:
> 
> /*
>  * The code relies on FOO being a power of 2.  If you break this,
>  * you're dumb.
>  */
> #define FOO_SHIFT	6
> #define FOO		(1 << FOO_SHIFT)
> 
> Your thoughts?

Given the probably-hundreds of sites which could utilise this assertion,
that approach will be a bit of a PITA.

