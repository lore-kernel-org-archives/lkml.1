Return-Path: <linux-kernel-owner+w=401wt.eu-S965978AbXDGWbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965978AbXDGWbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965981AbXDGWbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:31:09 -0400
Received: from pop5-1.us4.outblaze.com ([205.158.62.125]:35328 "HELO
	pop5-1.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965978AbXDGWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:31:08 -0400
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
From: Nigel Cunningham <ncunningham@linuxmail.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070407150612.f99aae4a.akpm@linux-foundation.org>
References: <200704072320.40238.rjw@sisk.pl>
	 <20070407150612.f99aae4a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 08 Apr 2007 08:31:05 +1000
Message-Id: <1175985065.10725.20.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-04-07 at 15:06 -0700, Andrew Morton wrote:
> On Sat, 7 Apr 2007 23:20:39 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This should allow us to reduce the memory usage, practically always, and
> > improve performance.
> 
> And does it?

It will. I've been using extents for ages, for the same reasons. I don't
put them in an rb_tree because I view it as less than most efficient,
but it will still be a huge step forward from bitmaps in the normal
case.

The worst case would be if every second page of swap was in use, so that
you needed one extent per swap page. In that case, it would use more
memory than the bitmap, but far, far more common will be the case where
only one extent is needed for the whole swap partition, because the
algorithm used by the swap allocator minimises fragmentation.

Regards,

Nigel

