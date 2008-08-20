Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYHTIiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYHTIiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYHTIip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:38:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbYHTIio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:38:44 -0400
Date: Wed, 20 Aug 2008 01:37:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
Message-Id: <20080820013736.ec64baae.akpm@linux-foundation.org>
In-Reply-To: <1219220003.3996.29.camel@localhost.localdomain>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	<20080818233824.5d219105.akpm@linux-foundation.org>
	<1219220003.3996.29.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 09:13:23 +0100 Ian Campbell <ijc@hellion.org.uk> wrote:

> Perhaps applying the band-aid at open time instead would be preferred?

That would be less racy, I expect.  Implement fb_ops.fb_open() within
drivers/video/fb_defio.c and do the address_space_operations overwrite
there.  Hopefully that will ensure that the address_space_operations
instance is stable before anyone uses it for anything serious.

It'd be better to hook in at inode creation time but afaict that's not
available for the /dev/fb0 node.

<tries to write a patch>

OK, seems that fb_ops.fb_open() has no way of getting at the `struct
file *' which is being opened (wtf?).  Screwed.  Need to change
fb_ops.fb_open(), or add a new fb_ops.fb_open_sane().




