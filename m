Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZCQD06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZCQD06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZCQD0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:26:47 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:48580 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZCQD0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:26:47 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090316180538.GA7069@kroah.com>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com>
Date: Tue, 17 Mar 2009 12:26:42 +0900
Message-ID: <7200.1237260402@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you very much for reviewing.

Greg KH:
> > +/* todo: file size may exceed PAGE_SIZE */
> > +ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
> > +			 char *buf)
> 
> NO IT CAN NOT!!!!
> 
> You are using sysfs wrong if you even think you are getting close to
> PAGE_SIZE.

The main reason I left a comment about PAGE_SIZE is that some of aufs
entry under sysfs contain the file path. And I don't think it is a good
idea to create a symlink since the path may be changed as a result of
users operation.
I left it as "todo" because such long path is rare.

If you have an idea to show users any file path which may be changed
dynamically, please let me know. At the beginning I have tried procfs,
but I was told that newer module should use sysfs instead of procfs. If
sysfs doesn't suit a path, what should I use? Debugfs?


> Please, use debugfs for this.  sysfs is a "one value per file" type
> filesystem.  You should never be using the seqfile interface for a sysfs
> file, that's a sure sign something is wrong in your design.
> 
> I think I'll stop reading now :(

I will change some entries which doesn't contain a file path (or make
them not to have have) and post again. So please don't stop reading.


J. R. Okajima
