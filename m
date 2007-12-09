Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXLIIJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXLIIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 03:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLIIJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 03:09:50 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34162 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXLIIJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 03:09:50 -0500
Date: Sun, 9 Dec 2007 09:11:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] kbuild: implement modules.order, take #2
Message-ID: <20071209081138.GB4954@uranus.ravnborg.org>
References: <475936CE.70703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475936CE.70703@gmail.com>
User-Agent: Mutt/1.4.2.1i
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
> Cc: Kay Sievers <kay.sievers@vrfy.org>

Applied to kbuild.git.

	Sam
