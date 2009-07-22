Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZGVSws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZGVSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbZGVSws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:52:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbZGVSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:52:47 -0400
Date: Wed, 22 Jul 2009 11:51:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@sun.com>
Cc: neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-Id: <20090722115155.f99dcf76.akpm@linux-foundation.org>
In-Reply-To: <20090722183244.GO4231@webber.adilger.int>
References: <19041.4714.686158.130252@notabene.brown>
	<20090721235904.42e6cd35.akpm@linux-foundation.org>
	<20090722183244.GO4231@webber.adilger.int>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 12:32:44 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Jul 21, 2009  23:59 -0700, Andrew Morton wrote:
> > On Sat, 18 Jul 2009 10:08:10 +1000 Neil Brown <neilb@suse.de> wrote:
> > I expect that the VFS could be made to work with 64-bit pgoff_t fairly
> > easily.  The generated code will be pretty damn sad.
> > 
> > radix-trees use a ulong index, so we would need a new
> > lib/radix_tree64.c or some other means of fixing that up.
> > 
> > The bigger problem is filesystems - they'll each need to be checked,
> > tested, fixed and enabled.  It's probably not too bad for the
> > mainstream filesystems which mostly bounce their operations into VFS
> > libarary functions anyway.
> 
> I don't think this is a primary concern for most filesystems even today.
> Filesystems that work correctly > 16TB on 64-bit platforms should continue
> to work correctly on 32-bit platforms.

Not if they use an unsigned long to hold a pagecache index anywhere.

akpm:/usr/src/25> grep 'unsigned long' fs/*/*.c | wc -l
3465
