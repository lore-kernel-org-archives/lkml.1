Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYFEP6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYFEP6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYFEP6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:58:24 -0400
Received: from waste.org ([66.93.16.53]:49565 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbYFEP6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:58:24 -0400
Subject: Re: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user
	instead of put_user.
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
References: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 10:57:57 -0500
Message-Id: <1212681477.3953.154.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 11:04 -0400, Thomas Tuttle wrote:
> While fiddling with pagemap, I discovered a bug in add_to_pagemap.
> When it is copying an entry that is not at the end of the buffer, it
> uses put_user to copy a u64 into a char* buffer.  The problem is that
> put_user determines how much to copy based on the size of the
> *destination*, not the source, so it only copied one byte.  To fix
> this, I replaced the call to put_user with a call to copy_to_user, as
> is used when copying the last (possibly partial) PFN into the buffer.

This looks fine to me, so:

Acked-by: Matt Mackall <mpm@selenic.com>

But your 3/5 undoes this, right? So we should just take one or the other
route. While I like going the simplifying route, it's not very pretty
from the user interface point of view. But it does have plenty of
precedent in direct-I/O-like things.

-- 
Mathematics is the supreme nostalgia of our time.

