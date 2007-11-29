Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbXK2R2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbXK2R2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbXK2R2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:28:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbXK2R2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:28:16 -0500
Date: Thu, 29 Nov 2007 09:27:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 05/11] x86 ptrace getreg/putreg merge
Message-Id: <20071129092715.2674bfe1.akpm@linux-foundation.org>
In-Reply-To: <20071129115954.12D3126F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129115954.12D3126F8E7@magilla.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 03:59:54 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:

> +/*
> + * Determines whether a value may be installed in a segment register.
> + */
> +#define invalid_selector(value) \
> +	((value) != 0 && ((value) & SEGMENT_RPL_MASK) != USER_RPL)

This didn't need to be implemented as a macro hence it shouldn't have been.

It references its arg more than once and is dangerous.  Calling
invalid_selector(foo++) will increment foo by one or two, depending upon
foo's value.

