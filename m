Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbXHHQjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbXHHQjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbXHHQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:39:42 -0400
Received: from lazybastard.de ([212.112.238.170]:50701 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762982AbXHHQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:39:40 -0400
Date: Wed, 8 Aug 2007 18:35:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: LogFS take five
Message-ID: <20070808163545.GU15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org> <1186590437.19606.38.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1186590437.19606.38.camel@sauron>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 August 2007 19:27:17 +0300, Artem Bityutskiy wrote:
> On Wed, 2007-08-08 at 18:12 +0200, Jörn Engel wrote:
> > It has been a while, mainly because I found a bunch of races and didn't
> > want to publish anything before those were fixed.  Patch is still
> > against 2.6.21 and just for review.
> 
> I'm very interested how do you account free/dirty space in LogFS:

Independently of the position where data goes.  There is a known amount
of space.  Each write decreases that, each delete increases that.
-ENOSPC when it gets too low.

> * When you need to write new data, how do you select the place where to
> write?

Next position in the appropriate segment (you remember the level
concept, I'm sure).

> * When you run out of space, how do select find the segment to
> garbage-collect?

Most amount of free space usually.  If space gets really tight, lower
levels are ignored.

> For any given segment (or eraseblock), how do you find amount of free
> and dirty space in it?

Scanning.  I don't have seperate accounting yet.

Jörn

-- 
When in doubt, use brute force.
-- Ken Thompson
