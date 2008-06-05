Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbYFEQWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbYFEQWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYFEQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:21:56 -0400
Received: from waste.org ([66.93.16.53]:45169 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYFEQVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:21:55 -0400
Subject: Re: [PATCH 3/5] pagemap: Make pagemap_read enforce reading in
	multiples of 8
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050914v5dc78fbcv373b08f09e37a337@mail.gmail.com>
References: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
	 <1212681822.3953.162.camel@calx>
	 <4ca0a85e0806050905j6cf33f3dx9143333aa0a8b6e7@mail.gmail.com>
	 <1212682175.3953.169.camel@calx>
	 <4ca0a85e0806050914v5dc78fbcv373b08f09e37a337@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:21:25 -0500
Message-Id: <1212682885.3953.183.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 12:14 -0400, Thomas Tuttle wrote:
> On Thu, Jun 5, 2008 at 12:09 PM, Matt Mackall <mpm@selenic.com> wrote:
> > Yes, I got that, I'm just mathematically impaired this morning. Read
> > that as "when someone tries to do a *20* byte read, do a 16-byte read.."
> > In other words, round down to the nearest multiple of 8.
> 
> Oh.  I would seriously question doing that, because it would allow
> reads that are improperly split up to fail silently.  What happens if
> someone tries to read 40 bytes, and (for some reason) it gets split
> into two 20-byte reads?  Instead of "12345" they'll get "12.34."
> (where . is 4 zero or garbage bytes).  I'd rather they get an error.

I suppose you're right, people usually don't check those return codes.

-- 
Mathematics is the supreme nostalgia of our time.

