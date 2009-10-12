Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZJLUhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZJLUhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZJLUhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:37:24 -0400
Received: from kroah.org ([198.145.64.141]:51055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbZJLUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:37:22 -0400
Date: Mon, 12 Oct 2009 13:34:07 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Message-ID: <20091012203407.GA30839@kroah.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 11:16:00PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Fix vmbus load hang caused by wrong data packing.

I also note that you are packing more structures here with this patch
than the code before the patch had.  Could that be the issue here?  The
additional structures are ones that should be packed instead?

If so, that might explain why things are working, just try to add the
packed attribute to the struct vmbus_channel and struct
vmbus_channel_debug_info and struct vmbus_channel_msginfo structures.

Although, if that solves the problem, then something else is seriously
wrong, as those structures should not being passed across the hypervisor
boundry...

thanks,

greg k-h
