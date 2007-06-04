Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbXFDBFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbXFDBFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXFDBFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:05:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57188 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXFDBFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:05:46 -0400
Date: Mon, 4 Jun 2007 02:05:44 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
Message-ID: <20070604010544.GX4095@ftp.linux.org.uk>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKKEMFEEAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEMFEEAC.davids@webmaster.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 05:27:06PM -0700, David Schwartz wrote:
> 
> > Now, Netapp speed aside, O_NONBLOCK and O_DIRECT seem to make zero
> > difference to my open times.  Example:
> >
> > open("/somefile", O_WRONLY|O_NONBLOCK|O_CREAT, 0644) = 1621 <0.415147>
 
> The 'open' function must, at minimum, confirm that the file exists (or
> doesn't exist and can be created, or whatever). This takes however long it
> takes on NFS.
> 
> You need either threads or a working asynchronous system call interface.
> Short of that, you need your own NFS client code.

BTW, why close these suckers all the time?  It's not that kernel would
be unable to hold thousands of open descriptors for your process...
Hash descriptors by pathname and be done with that; don't bother with
close unless you decide that you've got too many of them (e.g. when you
get a hash conflict).
