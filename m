Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZECSMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZECSMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZECSLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:11:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33302 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZECSLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:11:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 May 2009 11:07:26 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <20090503064432.GS8633@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0905031103290.7899@makko.or.mcafeemobile.com>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090503064432.GS8633@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Al Viro wrote:

> On Mon, Apr 27, 2009 at 02:33:34PM -0400, Gregory Haskins wrote:
> > +	/* We re-use eventfd for irqfd */
> > +	fd = sys_eventfd2(0, 0);
> > +	if (fd < 0) {
> > +		ret = fd;
> > +		goto fail;
> > +	}
> > +
> > +	/* We maintain a reference to eventfd for the irqfd lifetime */
> > +	file = eventfd_fget(fd);
> > +	if (IS_ERR(file)) {
> > +		ret = PTR_ERR(file);
> > +		goto fail;
> > +	}
> > +
> > +	irqfd->file = file;
> 
> This is just plain wrong.  You have no promise whatsoever that caller of
> that sucker won't race with e.g. dup2().  IOW, you can't assume that
> file will be of the expected kind.

The eventfd_fget() checks for the file_operations pointer, before 
returning the file*, and fails if the fd in not an eventfd. Or you have 
other concerns?



- Davide


