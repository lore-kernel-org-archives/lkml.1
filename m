Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbYENOco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbYENOco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760541AbYENOcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:32:35 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59712 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760485AbYENOcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:32:35 -0400
Date: Wed, 14 May 2008 18:32:15 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [1/1] Export __lock_page_killable()
Message-ID: <20080514143214.GA12700@2ka.mipt.ru>
References: <20080514141157.GA27047@2ka.mipt.ru> <20080514151356.0cb4abfe@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514151356.0cb4abfe@core>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan.

On Wed, May 14, 2008 at 03:13:56PM +0100, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > There are users, who would like to use lock_page_killable() in modules,
> > so far there are no users in kernel, but for consistency it can be
> > exported without them.
> 
> Missing information #1: Who are the users and what are the URLs to the
> code in question

POHMELFS wants to use that in two places: one to lock page in writeback,
another one is about second part of the message - it waits for timeout
or signal or locks the page. If page can not be locked, it performs own
steps, not sleeps forever...

POHMELFS is a high performance network filesystem, homepage for interested
reader:
http://tservice.net.ru/~s0mbre/old/?section=projects&item=pohmelfs
or yesterdays mail to mail lists:
http://lwn.net/Articles/282010/

> > Not that it is particulary needed
> 
> Humm..

I copied page_waitqueue() and use wait_on_bit() logic myself.
Andrew choked with his breakfast when saw that.

> > +EXPORT_SYMBOL(__lock_page_killable);
> 
> _GPL - or better yet this could be added *when* we have an actual in tree
> user who really needs it and can show it is appropriate to export.
> That'll also save Adrian from removing it again ;)

No problem wiht GPL-only exporting, but carring it over the whole
release means no ability to build out-of-tree module.

Actually what I want to hear, is that it is needed or not at all...

-- 
	Evgeniy Polyakov
