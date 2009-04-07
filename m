Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZDGACi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZDGACi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZDGAC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:02:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZDGAC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:02:27 -0400
Message-ID: <49DA9800.2090905@zytor.com>
Date: Mon, 06 Apr 2009 17:02:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Randy Robertson <rmrobert@vmware.com>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] initramfs: Fix initramfs to work with hardlinked init
References: <20090406192238.GA6621@vmware.com>
In-Reply-To: <20090406192238.GA6621@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Robertson wrote:
> Change cb6ff208076b5f434db1b8c983429269d719cef5 seems to have broken
> booting from initramfs with /sbin/init being a hardlink.  It seems like
> the logic required for XIP on nommu, i.e. ftruncate to reported cpio
> header file size (body_len) is broken for hardlinks, which have
> a reported size of 0, and the truncate thus nukes the contents of the
> file (in my case busybox), making boot impossible and ending with runaway
> loop modprobe binfmt-0000 - and of course 0000 is not a valid binary format.
> 
> My fix is to only call ftruncate if size is non-zero which fixes things
> for me, but I'm not certain whether this will break XIP for those files
> on nommu systems, although I would guess not.
> 
> This update adds David's ack and fixes whitespace.
> 
> Signed-off-by: Randy Robertson <rmrobert@vmware.com>
> Acked-by: David Howells <dhowells@redhat.com>

Looks right to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

