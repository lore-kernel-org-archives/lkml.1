Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbXKUSbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbXKUSbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXKUSbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:31:16 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54844 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbXKUSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:31:15 -0500
Subject: Re: [PATCH 5/5] x86: TLS cleanup
From: Zachary Amsden <zach@vmware.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071121102511.08B8A26F8BE@magilla.localdomain>
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
	 <20071121102511.08B8A26F8BE@magilla.localdomain>
Content-Type: text/plain
Date: Wed, 21 Nov 2007 10:34:39 -0800
Message-Id: <1195670079.6352.252.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 02:25 -0800, Roland McGrath wrote:
> This consolidates the four different places that implemented the same
> encoding magic for the GDT-slot 32-bit TLS support.  The old tls32.c is
> renamed and only slightly modified to be the shared implementation guts.

> -#define GET_BASE(desc) ( \
> -	(((desc)->a >> 16) & 0x0000ffff) | \
> -	(((desc)->b << 16) & 0x00ff0000) | \
> -	( (desc)->b        & 0xff000000)   )
> -
> -#define GET_LIMIT(desc) ( \
> -	((desc)->a & 0x0ffff) | \
> -	 ((desc)->b & 0xf0000) )

That was the other redundant definition, thanks.

I had a bit of trouble verifying correctness here because of much
brownian motion.  Any possibility of a pure movement / fixup separation
to make it easier on the eyes?

Zach

