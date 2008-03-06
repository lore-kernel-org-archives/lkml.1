Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbYCFMgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbYCFMgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYCFMfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:35:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYCFMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:35:51 -0500
Date: Thu, 6 Mar 2008 07:35:51 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
Message-ID: <20080306123551.GA10609@infradead.org>
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:43:32AM +0100, Laurent Vivier wrote:
> This patch allows to use loop device with partitionned disk image.
> 
> Original behavior of loop is not modified.
> 
> A new parameter is introduced to define how many partition we want to be
> able to manage per loop device. This parameter is "max_part".

I've done something else before as have done others, but at that time
we didn't want it in because it breaks the device number encoding.

Nowdays where a lot of systems use udev it probably makes sense to put
it in.  The default is to not show any partitions which is safe.  Did
you test if udev is smart enough to find out loop has partitions when
loaded with the paramater?  If yes this can go in with a little
documentation added, if not please also work with the udev folks to
find a way to automatically detect that loop can sometimes support
partitions.
