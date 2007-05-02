Return-Path: <linux-kernel-owner+w=401wt.eu-S2992869AbXEBHKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992869AbXEBHKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992874AbXEBHKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:10:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992869AbXEBHKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:10:15 -0400
Date: Wed, 2 May 2007 00:10:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
Message-Id: <20070502001000.8460fb31.akpm@linux-foundation.org>
In-Reply-To: <46383742.9050503@imap.cc>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46338AEB.2070109@imap.cc>
	<20070428141024.887342bd.akpm@linux-foundation.org>
	<4636248E.7030309@imap.cc>
	<20070430112130.b64321d3.akpm@linux-foundation.org>
	<46364346.6030407@imap.cc>
	<20070430124638.10611058.akpm@linux-foundation.org>
	<46383742.9050503@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 09:01:22 +0200 Tilman Schmidt <tilman@imap.cc> wrote:

> Am 30.04.2007 21:46 schrieb Andrew Morton:
> > Not really - everything's tangled up.  A bisection search on the
> > 2.6.21-rc7-mm2 driver tree would be the best bet.
> 
> And the winner is:
> 
> gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch
> 
> Reverting only that from 2.6.21-rc7-mm2 gives me a working kernel
> again.

cripes.

+static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
+                          char *buf)
+{
+       struct kobject *top_kobj;
+       struct kset *kset;
+       char *envp[32];
+       char data[PAGE_SIZE];

That won't work too well with 4k stacks.

Who's reviewing this stuff?  The patch headers indicate that no mailing list was
cc'ed?
