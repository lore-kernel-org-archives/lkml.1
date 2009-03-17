Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbZCQDjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbZCQDjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZCQDjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:39:14 -0400
Received: from kroah.org ([198.145.64.141]:34995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbZCQDjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:39:13 -0400
Date: Mon, 16 Mar 2009 20:37:47 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries
Message-ID: <20090317033747.GA17037@kroah.com>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com> <7200.1237260402@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7200.1237260402@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 12:26:42PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Thank you very much for reviewing.
> 
> Greg KH:
> > > +/* todo: file size may exceed PAGE_SIZE */
> > > +ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
> > > +			 char *buf)
> > 
> > NO IT CAN NOT!!!!
> > 
> > You are using sysfs wrong if you even think you are getting close to
> > PAGE_SIZE.
> 
> The main reason I left a comment about PAGE_SIZE is that some of aufs
> entry under sysfs contain the file path.

Which should be MAX_PATH, right?  Is that ever bigger than PAGE_SIZE?

> And I don't think it is a good idea to create a symlink since the path
> may be changed as a result of users operation.
> I left it as "todo" because such long path is rare.
> 
> If you have an idea to show users any file path which may be changed
> dynamically, please let me know. At the beginning I have tried procfs,
> but I was told that newer module should use sysfs instead of procfs. If
> sysfs doesn't suit a path, what should I use? Debugfs?

What specifically are you trying to show here?

> > Please, use debugfs for this.  sysfs is a "one value per file" type
> > filesystem.  You should never be using the seqfile interface for a sysfs
> > file, that's a sure sign something is wrong in your design.
> > 
> > I think I'll stop reading now :(
> 
> I will change some entries which doesn't contain a file path (or make
> them not to have have) and post again. So please don't stop reading.

Please document your sysfs entries, and I'll be glad to review it again.

thanks,

greg k-h
