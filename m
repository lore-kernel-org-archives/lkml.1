Return-Path: <linux-kernel-owner+w=401wt.eu-S932380Ab0AGIgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0AGIgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858Ab0AGIgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:36:51 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:57481 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0AGIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:36:51 -0500
Date: Thu, 7 Jan 2010 03:36:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Roland Dreier <rdreier@cisco.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] Add BUILD_BUG_ON_NOT_POWER_OF_2()
In-Reply-To: <adaeim2supb.fsf_-_@roland-alpha.cisco.com>
Message-ID: <alpine.LFD.2.00.1001070332060.16874@localhost>
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com> <20100106123306.ac85e557.akpm@linux-foundation.org> <aday6kbt14a.fsf@roland-alpha.cisco.com> <20100106134232.0025e818.akpm@linux-foundation.org> <adaeim2supb.fsf_-_@roland-alpha.cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Roland Dreier wrote:

> When code relies on a constant being a power of 2:
>
> 	#define FOO	512	/* must be a power of 2 */
>
> it would be nice to be able to do:
>
> 	BUILD_BUG_ON(!is_power_of_2(FOO));
>
> However applying an inline function does not result in a
> compile-time constant that can be used with BUILD_BUG_ON(), so
> trying that gives results in:
>
> 	error: bit-field '<anonymous>' width not an integer constant
>
> As suggested by akpm, rather than monkeying around with
> is_power_of_2() and risking gcc warts about constant expressions,
> just create a macro BUILD_BUG_ON_NOT_POWER_OF_2() to encapsulate
> this common requirement.

  my normal pedantry coming to the surface, but can we at least assume
that people will use this test to *legitimately* test whether or not
something is a power of two, and not that there is a single bit set
(in the case of mask bits where all settings must be mutually
exclusive)?

  there's a lot of this sort of thing throughout the kernel:

    (n) != 0 && (((n) & ((n) - 1))

but it's sometimes unclear whether someone is testing for a) power of
two, or b) single bit set.  if you're going to introduce that kind of
BUILD BUG (which is a good idea), let's try to not immediately abuse
it semantically. :-)

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
