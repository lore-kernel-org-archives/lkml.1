Return-Path: <linux-kernel-owner+w=401wt.eu-S965219AbXBQMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965219AbXBQMeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXBQMeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:34:18 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:29502 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965219AbXBQMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:34:18 -0500
Subject: Re: [PATCH 2.6.20 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20070217104215.GB25512@localhost>
References: <20070217104215.GB25512@localhost>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 13:34:12 +0100
Message-Id: <1171715652.5186.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 11:42 +0100, Jaya Kumar wrote:
> Hi James, Geert, lkml and mm,

Hi Jaya,

> This patch adds support for the Hecuba/E-Ink display with deferred IO.
> The changes from the previous version are to switch to using a mutex
> and lock_page. I welcome your feedback and advice.

This changelog ought to be a little more extensive; esp. because you're
using these fancy new functions ->page_mkwrite() and page_mkclean() in a
novel way.

Also, I'd still like to see a way to call msync() on the mmap'ed region
to force a flush. I think providing a fb_fsync() method in fbmem.c and a
hook down to the driver ought to work.

Also, you now seem to use a fixed 1 second delay, perhaps provide an
ioctl or something to customize this?

And, as Andrew suggested last time around, could you perhaps push this
fancy new idea into the FB layer so that more drivers can make us of it?


