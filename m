Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbYFEQKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbYFEQKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYFEQKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:10:36 -0400
Received: from waste.org ([66.93.16.53]:49246 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYFEQKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:10:35 -0400
Subject: Re: [PATCH 3/5] pagemap: Make pagemap_read enforce reading in
	multiples of 8
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050905j6cf33f3dx9143333aa0a8b6e7@mail.gmail.com>
References: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
	 <1212681822.3953.162.camel@calx>
	 <4ca0a85e0806050905j6cf33f3dx9143333aa0a8b6e7@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:09:35 -0500
Message-Id: <1212682175.3953.169.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 12:05 -0400, Thomas Tuttle wrote:
> On Thu, Jun 5, 2008 at 12:03 PM, Matt Mackall <mpm@selenic.com> wrote:
> >
> > On Thu, 2008-06-05 at 11:06 -0400, Thomas Tuttle wrote:
> >> Since kpagecount and kpageflags require reads in multiples of 8, and
> >> it simplifies add_to_pagemap significantly, I added the same
> >> requirement to /proc/pid/pagemap.
> >
> > I'm generally fine with this. Another approach that's perhaps more
> > friendly is when someone tries to do a 24-byte read, do a 16-byte read,
> > leaving the file pointer aligned. Not sure if that's completely kosher
> > though.
> 
> This doesn't require that they read exactly 8 bytes, just that they
> read some multiple of 8 bytes.  (They can read 8, 16, 24, etc..., just
> not something like 12.)

Yes, I got that, I'm just mathematically impaired this morning. Read
that as "when someone tries to do a *20* byte read, do a 16-byte read.."
In other words, round down to the nearest multiple of 8.

-- 
Mathematics is the supreme nostalgia of our time.

