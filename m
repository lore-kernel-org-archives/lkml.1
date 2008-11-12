Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYKLXTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYKLXTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYKLXTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:19:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbYKLXTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:19:14 -0500
Date: Wed, 12 Nov 2008 15:17:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: julia@diku.dk, mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/media: use ARRAY_SIZE
Message-Id: <20081112151742.a0da237c.akpm@linux-foundation.org>
In-Reply-To: <20081109091427.1d6bdfcd@infradead.org>
References: <Pine.LNX.4.64.0811091754410.32509@ask.diku.dk>
	<20081109091427.1d6bdfcd@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 09:14:27 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 9 Nov 2008 17:55:03 +0100 (CET)
> Julia Lawall <julia@diku.dk> wrote:
> 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > ARRAY_SIZE is more concise to use when the size of an array is
> > divided by the size of its type or the size of its first element.
> 
> Hi,
> looking at your patch, I don't think I agree it's just blindly the
> right thing to do.
> 
> > -	*count = sizeof(RegAddr) / sizeof(u8);
> > +	*count = ARRAY_SIZE(RegAddr);

It looks OK to me?

	u8 RegAddr[] = {
		11, 12, 13, 22, 32, 43, 44, 53, 56, 59, 73,
		76, 77, 91, 134, 135, 137, 147,
		156, 166, 167, 168, 25 };

	*count = sizeof(RegAddr) / sizeof(u8);


> really. ARRAY_SIZE doesn't appear to be an improvement here..

It's a pretty typical usage of ARRAY_SIZE.  The benefits are, as usual:

- the ARRAY_SIZE construct *tells* the reader what the code is trying
  to do.  Rather than the reader having to work it out and then say "oh
  yeah, that's what it's doing".

- a reviewer doesn't have to go back and double-check that correct
  type was used.

