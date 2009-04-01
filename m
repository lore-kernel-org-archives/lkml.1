Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZDALKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZDALKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbZDALKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:10:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32883 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZDALKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:10:08 -0400
Date: Wed, 1 Apr 2009 12:10:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: fs: move bdev code out of buffer.c
Message-ID: <20090401111003.GZ28946@ZenIV.linux.org.uk>
References: <200903280059.n2S0xvhK006987@hera.kernel.org> <20090330115524.e78dbe14.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330115524.e78dbe14.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 11:55:24AM -0700, Andrew Morton wrote:

> This patch moved the CONFIG_BLOCK=y declaration of freeze_bdev() out of
> buffer_head.h and into fs.h.  But it left the CONFIG_BLOCK=n definition
> of freeze_bdev() in buffer_head.h.

Actually, there's more.
	a) fsync_bdev() export is left behind in buffer.c
	b) sync_blockdev/invalidate_bdev are like freeze_bdev/thaw_bdev -
non-block stubs need to be moved.

Fixed and pushed into for-next
