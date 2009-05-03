Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZECUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZECUbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbZECUbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:31:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34787 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbZECUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:31:14 -0400
Date: Sun, 3 May 2009 21:31:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090503203111.GB8633@ZenIV.linux.org.uk>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090503064432.GS8633@ZenIV.linux.org.uk> <alpine.DEB.1.10.0905031103290.7899@makko.or.mcafeemobile.com> <20090503190136.GY8633@ZenIV.linux.org.uk> <alpine.DEB.1.10.0905031252540.7899@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905031252540.7899@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 01:11:39PM -0700, Davide Libenzi wrote:
> On Sun, 3 May 2009, Al Viro wrote:
> 
> > IOW, the sane solution would be to export something that returns your
> > struct file *.  And stop playing with fd completely.
> 
> This builds but it's not tested at all.
> 
> - Make all the work of the old anon_inode_getfd(), done by a new 
>   anon_inode_getfile(), with anon_inode_getfd() using its services
> 
> - Make all the work done by sys_eventfd(), done by a new 
>   eventfd_file_create() (which in turn uses anon_inode_getfile()), with 
>   sys_eventfd() using its services
> 
> IRQfd can use eventfd_file_create(), fget(), get_unused_fd_flags() and 
> fd_install() just before returning.
> Is that what you had in mind?

More or less, but I'd like to see the irqfd side of that...
