Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbXK2IDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbXK2IDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbXK2IC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:02:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:7755 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbXK2ICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lXHwyyChlHbXf/eDAycYd4DDk/3AA2I9XbJjup455XnJwe3B7sjG3P4XwrJAA/HdgfZiMzJluFrZ2Y5IpdcPBLAPQaZ4Cg0KUjmMjQpU4S3O/YndYeFREa0GX4I7Tv36NbLTL2xoAC9UCVTTg1rqjc0KDcUTvjV5al6Aw7g1K3s=
Message-ID: <84144f020711290002p290e91a4ubc40f1efbc877f75@mail.gmail.com>
Date: Thu, 29 Nov 2007 10:02:55 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <474C34CC.6060509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474C34CC.6060509@gmail.com>
X-Google-Sender-Auth: 2f4aef53b5e8a8b3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Nov 27, 2007 5:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> +config KMEMCHECK
> +       bool "Trap use of uninitialized memory"
> +       depends on X86_32 && !CC_OPTIMIZE_FOR_SIZE
> +       help
> +         This option enables tracing of dynamically allocated kernel memory
> +         to see if memory is used before it has been given an initial value.
> +         Be aware that this requires half of your memory for bookkeeping and
> +         will insert extra code at *every* read and write to tracked memory
> +         thus slow down the kernel code (but user code is unaffected).

Is it really necessary to track every memory address? Tracking slab
objects would require far less memory. You might also want to make
kzalloc() and GFP_ZERO mark the memory area as initialized to avoid
some page faults.

On Nov 27, 2007 5:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> +       /* Actually allocate twice as much, since we need to track the
> +        * status of each byte within the allocation. */
> +       if (!(flags & __GFP_NOTRACK)) {

If you change __GFP_NOTRACK to __GFP_TRACK, you can avoid the double
negation here.

                                    Pekka
