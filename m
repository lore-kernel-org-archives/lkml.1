Return-Path: <linux-kernel-owner+w=401wt.eu-S1946408AbXBCI5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946408AbXBCI5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946410AbXBCI5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:57:53 -0500
Received: from waste.org ([66.93.16.53]:44288 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946408AbXBCI5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:57:52 -0500
Date: Sat, 3 Feb 2007 02:45:26 -0600
From: Matt Mackall <mpm@selenic.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: a quick survey:  "FIELD_SIZEOF" or "MEMBER_SIZE"?
Message-ID: <20070203084526.GG16722@waste.org>
References: <Pine.LNX.4.64.0702030243350.23432@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702030243350.23432@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 02:49:34AM -0500, Robert P. J. Day wrote:
> 
>   pardon the interruption but, once upon a time, we were discussing
> cleaning up code to use the kernel.h-defined macro "FIELD_SIZEOF".
> 
>   some folks suggested that the macro name itself was kind of awkward
> as it didn't fit the pattern of "ARRAY_SIZE" defined in that same
> header file.
> 
>   because of a name clash, "FIELD_SIZE" is not available, but there
> was a suggestion of, uh, "MEMBER_SIZE".  :-)
> 
>   so, really, those are the two viable choices -- stick with the
> current name of FIELD_SIZEOF, or switch to MEMBER_SIZE.  switching is
> not a big deal since no one (at least, no one in the current tree)
> uses FIELD_SIZEOF as it is, so it's not as if it would be a disruptive
> change in the slightest.

K&R calls them 'members'. 

We've currently got:

sizeof (built-in)
typeof (built-in)
offsetof (standard macro)
container_of (kernel macro) (1800 of these, ugh)

We don't want:

FIELD_SIZE - they're members
MEMBER_SIZE - inconsistent with the above
member_size - all the above have of
member_size_of - inconsistent with sizeof
member_sizeof - inconsistent _ between words
sizeof_member - same, plus other issues
memsizeof - confusion with memory

So my vote would be for:

membersizeof(a, b)

There's also at least two pieces of code that could use:

membertypeof(a, b)

And please kill all the reimplementations of offsetof while you're at it.

-- 
Mathematics is the supreme nostalgia of our time.
