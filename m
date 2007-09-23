Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbXIWUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbXIWUFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbXIWUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:05:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48036
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477AbXIWUFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:05:42 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Sun, 23 Sep 2007 15:05:37 -0500
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
In-Reply-To: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231505.37410.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 September 2007 2:27:29 pm Vegard Nossum wrote:
> After recent discussions on LKML and a general dissatisfaction at the
> current printk() kernel-message logging interface, I've decided to
> write down some of the ideas for a better system.
>
>
> Requirements
> ============
>
>  * Backwards compatibility with printk(), syslog(), etc.

I.E. what we have now works just fine for what it does.

>  * Extensibility. Features like timestamping or file/line recording
> [1] should be both selectable at compile-time and (if compiled in) at
> run-time.

That doesn't require changing the API.  Allowing the compiler to eliminate 
messages below a threshold requires changing the API.

>
> API
> ===
>
> #define kprint(fmt, ...)
>
> The main part of the kprint interface should be the kprint() function.

And then you propose not having a single kprint() function...

> To support the different log-levels, there exists one kprint_*()
> function for each log-level, for example kprint_info().

Why is this better than feeding the level in as an argument to the macro?

> In order to print several related lines as one chunk, the emitter
> should first allocate an object of the type struct kprint_buffer.

You know, I'm pretty happy with a first pass that doesn't address this issue 
at all.  Why bundle three unrelated problems into a single all-or-nothing 
pass?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
