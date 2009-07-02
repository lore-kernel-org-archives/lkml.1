Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZGBRVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZGBRVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZGBRVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:21:12 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35541 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZGBRVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:21:12 -0400
Date: Fri, 3 Jul 2009 02:21:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: vapier.adi@gmail.com, rgetz@blackfin.uclinux.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating the stack size
Message-ID: <20090702172108.GA3951@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>, vapier.adi@gmail.com,
	rgetz@blackfin.uclinux.org, gerg@uclinux.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-kernel@vger.kernel.org
References: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 01:08:14PM +0100, David Howells wrote:
> Ignore the loader's PT_GNU_STACK when calculating the stack size, and only
> consider the executable's PT_GNU_STACK, assuming the executable has one.
> 
> Currently the behaviour is to take the largest stack size and use that, but
> that means you can't reduce the stack size in the executable.  The loader's
> stack size should probably only be used when executing the loader directly.
> 
> WARNING: This patch is slightly dangerous - it may render a system inoperable
> if the loader's stack size is larger than that of important executables, and
> the system relies unknowingly on this increasing the size of the stack.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Works for me too.

Acked-by: Paul Mundt <lethal@linux-sh.org>
