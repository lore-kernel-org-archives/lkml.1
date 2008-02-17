Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYBQGxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYBQGxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYBQGwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:52:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbYBQGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:52:52 -0500
Date: Sat, 16 Feb 2008 22:51:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: 2.6.25-rc2-mm1
Message-Id: <20080216225118.59a2170d.akpm@linux-foundation.org>
In-Reply-To: <20080217062540.GB26206@mail.oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080217062540.GB26206@mail.oracle.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 22:25:40 -0800 Joel Becker <Joel.Becker@oracle.com> wrote:

> On Sat, Feb 16, 2008 at 12:25:22AM -0800, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> ...
> > +avoid-divides-in-bits_to_longs.patch
> 
> Andrew,
> 	This patch, by introducing sizeof(long) in the BITS_TO_LONGS
> math, changes BITS_TO_LONGS from an int to a unsigned long.  We noticed
> because this printk in fs/ocfs2/dlm/dlmdomain.c:
> 
>     mlog(ML_ERROR,
>          "map_size %u != BITS_TO_LONGS(O2NM_MAX_NODES) %u\n",
>          map_size, BITS_TO_LONGS(O2NM_MAX_NODES));
> 
> now gives this warning:
> 
>     fs/ocfs2/dlm/dlmdomain.c:938: warning: format '%u' expects type
>     'unsigned int', but argument 7 has type 'long unsigned int'
> 
> We can tweak the printk once the patch goes to Linus, no worries.  I
> just wanted to send a heads up in case the size change affects anything
> else.
> 

Thanks.  That was not intentional and I'll drop the patch.
