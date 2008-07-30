Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYG3Ula@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYG3Ula (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYG3UlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:41:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbYG3UlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:41:14 -0400
Date: Wed, 30 Jul 2008 13:40:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH 2/2] firmware/memmap: Move kobject initialisation before
 kobject_add()
Message-Id: <20080730134011.24d10dfe.akpm@linux-foundation.org>
In-Reply-To: <20080730221424.0d997fb0@kopernikus.site>
References: <1217448752-13859-1-git-send-email-bwalle@suse.de>
	<1217448752-13859-3-git-send-email-bwalle@suse.de>
	<20080730221424.0d997fb0@kopernikus.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 22:14:24 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> * Bernhard Walle <bwalle@suse.de> [2008-07-30 22:12]:
> >
> > Because kobject_init() call could be done from firmware_map_add_entry()
> > which is called before kmalloc() can be used (we use the early bootmem allocator
> > here), move that call to memmap_init() which is a late_initcall.
> 
> You can leave out that patch now since kobject_init() was adapted with
> the other patch ... But I think it would still make sense to include
> that one.

What one?  Your thises and thats are confusing.

If you think that "firmware/memmap: Move kobject initialisation before
kobject_add()" should still be applied then I'd disagree.  Adding a
GFP_KERNEL allocation into kobject_init() was a fairly significant
backward step.  It's _good_ that kobject_init() can be called this
early.  Let us strive to retain that robustness.



