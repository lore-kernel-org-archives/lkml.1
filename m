Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYJCXqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYJCXqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYJCXqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:46:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYJCXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:46:36 -0400
Date: Fri, 3 Oct 2008 14:59:23 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Add c2 port support.
Message-ID: <20081003215923.GA14890@kroah.com>
References: <1223044589-31741-1-git-send-email-giometti@linux.it> <1223044589-31741-2-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223044589-31741-2-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 04:36:29PM +0200, Rodolfo Giometti wrote:
> C2port implements a two wire serial communication protocol (bit
> banging) designed to enable in-system programming, debugging, and
> boundary-scan testing on low pin-count Silicon Labs devices.
> 
> Currently this code supports only flash programming through sysfs
> interface but extensions shoud be easy to add.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  drivers/misc/Kconfig       |   13 +
>  drivers/misc/Makefile      |    1 +
>  drivers/misc/c2port_core.c |  996 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/c2port.h     |   65 +++

Why does this file have to be in include/linux?  I don't think this
exports any structures to userspace, and no other code calls this
driver, so it should all fit into the .c file just fine.

Also, please create the needed Documentation/ABI/ files for these new
sysfs entries, describing how they are used, and what the format of them
are.

Is there any way to detect automatically if this hardware is present in
the system or not?

Otherwise, how will it be loaded by a distro automatically?

thanks,

greg k-h
