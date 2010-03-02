Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0CBXns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:43:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab0CBXku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:40:50 -0500
Date: Tue, 2 Mar 2010 15:39:35 -0800
From: Greg KH <gregkh@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Take a 256 byte padding into account when
 buffering below sub-page units
Message-ID: <20100302233935.GA1278@suse.de>
References: <20100302222419.GE11355@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302222419.GE11355@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 10:24:19PM +0000, Mel Gorman wrote:
> (applies on top of linux-next, depends on "tty: Keep the default buffering to sub-page units")
> 
> The TTY layer takes some care to ensure that only sub-page allocations
> are made with interrupts disabled. It does this by setting a goal of
> "TTY_BUFFER_PAGE" to allocate. Unfortunately, while TTY_BUFFER_PAGE takes the
> size of tty_buffer into account, it fails to account that tty_buffer_find()
> rounds the buffer size out to the next 256 byte boundary before adding on
> the size of the tty_buffer.
> 
> This patch adjusts the TTY_BUFFER_PAGE calculation to take into account the
> size of the tty_buffer and the padding. Once applied, tty_buffer_alloc()
> should not require high-order allocations.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  include/linux/tty.h |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Thanks, I'll queue this up after the current round of patches make it
into Linus's tree.

greg k-h
