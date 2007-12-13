Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbXLMHXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbXLMHXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbXLMHNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:13:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46614 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764147AbXLMHNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:13:23 -0500
Date: Wed, 12 Dec 2007 23:11:56 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org
Subject: Re: [PATCH] kbuild: implement modules.order, take #2
Message-ID: <20071213071156.GC13764@kroah.com>
References: <475936CE.70703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475936CE.70703@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 09:04:30PM +0900, Tejun Heo wrote:
> When multiple built-in modules (especially drivers) provide the same
> capability, they're prioritized by link order specified by the order
> listed in Makefile.  This implicit ordering is lost for loadable
> modules.
> 
> When driver modules are loaded by udev, what comes first in
> modules.alias file is selected.  However, the order in this file is
> indeterministic (depends on filesystem listing order of installed
> modules).  This causes confusion.
> 
> The solution is two-parted.  This patch updates kbuild such that it
> generates and installs modules.order which contains the name of
> modules ordered according to Makefile.  The second part is update to
> depmod such that it generates output files according to this file.
> 
> Note that both obj-y and obj-m subdirs can contain modules and
> ordering information between those two are lost from beginning.
> Currently obj-y subdirs are put before obj-m subdirs.
> 
> Sam Ravnborg cleaned up Makefile modifications and suggested using awk
> to remove duplicate lines from modules.order instead of using separate
> C program.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Bill Nottingham <notting@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks for doing this, looks very nice.

greg k-h
