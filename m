Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906Ab0AMTnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0AMTnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535Ab0AMTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:43:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41962 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0AMTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:43:05 -0500
Date: Wed, 13 Jan 2010 19:43:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] procfs: Fix refcnt leak on proc_self_follow_link() error
 path
Message-ID: <20100113194300.GA4673@ZenIV.linux.org.uk>
References: <87aawkjxlf.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aawkjxlf.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:38:36AM +0900, OGAWA Hirofumi wrote:
> 
> If ->follow_link handler return the error, it should decrement
> nd->path refcnt.
> 
> This patch fix it.

It's OK for -stable, but for the next tree... not really.  I'd rather
kill vfs_follow_link() uses here and in gfs2; see #untested in vfs-2.6.git
for details.
