Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZJZLUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZJZLUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZJZLUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:20:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33705 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbZJZLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:20:34 -0400
Date: Mon, 26 Oct 2009 11:20:36 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Walls <awalls@radix.net>
Subject: Re: checkpatch is not detecting bad whitespacing when using macros
 on formulas
Message-ID: <20091026112036.GG12089@shadowen.org>
References: <20091011071911.54347f2b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011071911.54347f2b@pedra.chehab.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 07:19:11AM -0300, Mauro Carvalho Chehab wrote:
> Hi Andy Whitcroft,
> 
> While reviewing a patch from Andy Walls, I noticed that checkpatch v 0.29
> didn't get any errors when bad whitespacing is used on some formulas:
> 
> $ checkpatch.pl cx23888-ir-part2_2.patch
> total: 0 errors, 0 warnings, 1237 lines checked
> 
> cx23888-ir-part2_2.patch has no obvious style problems and is ready for submission.
> 
> However, there are several places at the patch like:
> 
> +static inline u16 ns_to_clock_divider(unsigned int ns)
> +{
> +       return count_to_clock_divider(
> +                 DIV_ROUND_CLOSEST(CX23888_IR_REFCLK_FREQ/1000000 * ns, 1000));
> +}

I assume the error you are pointing out is the lack of spacing round the
divide operator.  Though the guidelines ask for spacing on both sides
there are cases where it has been argued that no spacing is more
appropriate.  Once such case is where the expression is effectivly
generating a constant, such as that above and you will find a slew of
such uses in the kernel.  As a result the checkpatch check for this
spacing is actually slightly more liberal checking for consistant
spacing on either side, spaces both sides or neither.

-apw
