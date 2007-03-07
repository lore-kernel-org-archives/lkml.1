Return-Path: <linux-kernel-owner+w=401wt.eu-S1422712AbXCGKZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422712AbXCGKZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422714AbXCGKZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:25:06 -0500
Received: from main.gmane.org ([80.91.229.2]:42312 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422712AbXCGKZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:25:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@gmail.com>
Subject: Re: [PATCH - RFC] allow setting =?utf-8?b?dm1fZGlydHk=?= below 1% for large memory machines
Date: Wed, 7 Mar 2007 10:23:14 +0000 (UTC)
Message-ID: <loom.20070307T111716-18@post.gmane.org>
References: <17827.22798.625018.673326@notabene.brown> <Pine.LNX.4.64.0701110245300.22043@twinlark.arctic.org> <20070111122127.5bcc0b0f.akpm@osdl.org> <Pine.LNX.4.64.0701111431470.4980@twinlark.arctic.org> <20070111144801.ef86c169.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.190.39 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070219 Firefox/2.0.0.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > actually a global dirty_ratio causes interference between devices which 
> > should otherwise not block each other...
> > 
> > if you set up a "dd if=/dev/zero of=/dev/sdb bs=1M" it shouldn't affect 
> > write performance on sda -- but it does... because the dd basically 
> > dirties all of the "dirty_background_ratio" pages and then any task 
> > writing to sda has to block in the foreground...  (i've had this happen in 
> > practice -- my hack fix is oflag=direct on the dd... but the problem still 
> > exists.)
> 
> yeah.  Plus your heavy-dd-to-/dev/sda tends to block light-writers to
> /dev/sda in perhaps disproportionate ways.
> 
> This is on my list of things to look at.  Hah.

It really exists in the wild on both large memory and storage machines. I hope
we don't have to patch Samba on every release to add POSIX fadvise calls in
order to have a more polite VM. A 'cfq' for write generators from vm to devices
would be nice if it can auto probe the device write speed so we don't have to
use knobs. Just let the kernel figure out what are the best values to the
algorithms would be the ideal world.

