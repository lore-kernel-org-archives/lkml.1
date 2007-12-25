Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbXLYXtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbXLYXtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXLYXtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:49:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXLYXti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:49:38 -0500
Message-ID: <477196A9.3040205@zytor.com>
Date: Tue, 25 Dec 2007 15:47:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [x86] is checkpatch.pl broken
References: <20071225170737.GA3887@cvg.org>
In-Reply-To: <20071225170737.GA3887@cvg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Hi list,
> 
> by doing cleanup of arch/x86/boot/*.[ch] i found that
> checkpatch does ignore obvious things. For example,
> run it over edd.c showed only one warning:

I'm generally skeptical to the kind of "cleanups" that you seem to be 
referring to.  More often then not they reduce legibility instead of the 
opposite.

> ---
> cyrill@cvg linux-2.6.git $ scripts/checkpatch.pl --file arch/x86/boot/edd.c 
> WARNING: externs should be avoided in .c files
> #45: FILE: x86/boot/edd.c:45:
> +       extern char _end[];
> 
> total: 0 errors, 1 warnings, 167 lines checked
> 
> Your patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> ---
> 
> but on line 53 we have:
> 
> mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
> 
> so checkpatch should at least worn me about missed space
> btw math operators. Am I wrong?

If checkpatch considered that line to be a problem, I would consider 
checkpatch to be utterly broken.  That line is perfectly legible, and 
padding in a bunch of spaces would make it LESS so, especially since it 
would have to be split between lines.

	-hpa
