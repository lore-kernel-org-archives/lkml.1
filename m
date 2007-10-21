Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbXJUIzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbXJUIzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 04:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXJUIzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 04:55:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43498 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXJUIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 04:55:46 -0400
Subject: Re: BUG at mm/filemap.c:1749 (2.6.24, jffs2, unionfs)
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, jffs-dev@axis.com,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <200710191716.53470.nickpiggin@yahoo.com.au>
References: <200710190605.l9J65kDe008069@agora.fsl.cs.sunysb.edu>
	 <200710191703.12026.nickpiggin@yahoo.com.au>
	 <200710191716.53470.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Sun, 21 Oct 2007 09:55:44 +0100
Message-Id: <1192956944.2672.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-8.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 17:16 +1000, Nick Piggin wrote:
> 
>         if (writtenlen) {
> -               if (inode->i_size < (pg->index << PAGE_CACHE_SHIFT) + start + writtenlen) {
> -                       inode->i_size = (pg->index << PAGE_CACHE_SHIFT) + start + writtenlen;
> +               if (inode->i_size < pos + start + writtenlen) {
> +                       inode->i_size = pos + start + writtenlen;

This part seems wrong. Shouldn't it just be pos + writtenlen -- which is
basically what it was already: pos==(pg->index<<PAGE_CACHE_SHIFT)+start

-- 
dwmw2

