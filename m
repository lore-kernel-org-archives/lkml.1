Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbXGFXdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbXGFXdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 19:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXGFXd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 19:33:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36617 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbXGFXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 19:33:28 -0400
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070706222651.GG5777@v2.random>
References: <20070706222651.GG5777@v2.random>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 16:33:21 -0700
Message-Id: <1183764801.10287.233.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 00:26 +0200, Andrea Arcangeli wrote:
> for the hack week at opensuse (see http://idea.opensuse.org/) I've
> been working on a new feature called CONFIG_PAGE_SHIFT.
...
> If you want to help/look here the patch:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.22-rc7/hard-page-size
> 
> I'm tracking it with hg mq extension so far, but I can change if it
> helps.

The patch looks really interesting, it's just a little hard to parse
with all of the s/4096/PAGE_SIZE/ bits around.  Those cleanups, along
with the s/PAGE_SIZE/HARD_PAGE_SIZE/ parts would be great in a
separated-out patch so that the really juicy bits (like the pte
handling) where the new logic is stand out better.  

I think it would help readability to have something like:

#define PAGES_PER_HARD_PAGE (1<<(PAGE_SHIFT-HARD_PAGE_SHIFT))

which would look like this:

-	if (unlikely(!pfn_valid(pfn))) {
+	if (unlikely(!pfn_valid(pfn * PAGES_PER_HARD_PAGE))) {

Instead of having hardpfn_t, would it be more useful to tag the types
with sparse?  That's probably something that other interested parties
could work on.

-- Dave

