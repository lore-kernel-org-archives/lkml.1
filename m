Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYFHEhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYFHEhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 00:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYFHEh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 00:37:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34943 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYFHEh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 00:37:29 -0400
Date: Sat, 7 Jun 2008 21:32:10 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 15/25] Ramfs and Ram Disk pages are non-reclaimable
Message-ID: <20080608043210.GB21251@kroah.com>
References: <20080606202838.390050172@redhat.com> <20080606202859.408662219@redhat.com> <20080606180510.87a49e19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606180510.87a49e19.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 06:05:10PM -0700, Andrew Morton wrote:
> 
> Also, I expect there are a whole host of pseudo-filesystems (sysfs?)
> which have this problem.  Does the patch address all of them?  If not,
> can we come up with something which _does_ address them all without
> having to hunt down and change every such fs?

sysfs used to have this issue, until the people at IBM rewrote the whole
backing store for sysfs so that now it is reclaimable and pages out
quite nicely when there is memory pressure.  That's how they run 20,000
disks on the s390 boxes with no memory :)

But it would be nice to solve the issue "generically" for ram based
filesystems, if possible (usbfs, securityfs, debugfs, etc.)

thanks,

greg k-h
