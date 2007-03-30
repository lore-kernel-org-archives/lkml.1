Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbXC3Nn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbXC3Nn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXC3Nn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:43:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39532 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXC3Nn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:43:28 -0400
Date: Fri, 30 Mar 2007 14:43:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Eduard Bloch <edi@gmx.de>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070330134327.GA24030@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eduard Bloch <edi@gmx.de>, linux-kernel@vger.kernel.org,
	debburn-devel@lists.alioth.debian.org
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:17:44PM +0200, Eduard Bloch wrote:
> Hello,
> 
> I am talking this issue to LKML now.
> 
> Short story: using O_EXCL on /dev/srX alone does not help to prevent
> other process from killing your burn process by just reading the
> /dev/sgX device associated with yours, and vice versa. We have done the
> best we could to make safe operation (in contrary to Schilling's
> kill-this-evil-hald-thing bitching) but that is not enough, the locking
> has to be established on kernel layer.
> 
> Long story:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=413960
> https://bugzilla.novell.com/show_bug.cgi?id=226019
> http://lists.alioth.debian.org/pipermail/debburn-devel/2007-February/000297.html
> and other error messages.
> 
> There is AFAICS no simple way to establish locking across the driver
> borders. If kernel developers have a good idea, any help is appreciated.
> 
> Below are the typical symptoms: wodim operates via /dev/sgX because the
> user chosen it this way, some other process (most likely hald) comes
> along and reads from /dev/sr0 and the drive gets confused. Boom.

You have thre problems here, and none of them are in the kernel :)

First the hardsware is broken when it can't deal with concurrent requests,
I'd try to get a refund for it.  Second wodim should never ever use
/dev/sg if the sr node is available.  And third HAL should stop poking
devices all the time.  Then again hald is a totally lost cause and
I can only recommend to uninstall it ASAP.
