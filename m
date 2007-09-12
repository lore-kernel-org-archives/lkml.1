Return-Path: <linux-kernel-owner+w=401wt.eu-S967936AbXILMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967936AbXILMTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762180AbXILMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:18:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52523 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764982AbXILMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:18:51 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 12 Sep 2007 08:16:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Andre Haupt <andre@finow14.de>, torvalds@osdl.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: hci_sock.c build failure
In-Reply-To: <20070912120253.GA13003@kroah.com>
Message-ID: <Pine.LNX.4.64.0709120813580.7529@localhost.localdomain>
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain>
 <20070912120253.GA13003@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Greg KH wrote:

> On Wed, Sep 12, 2007 at 11:29:29AM +0200, Andre Haupt wrote:
> > Hi,
> >
> > I did a make randconfig and then make C=1.
> >
> > hci_sock.c fails to build because it doesnt know compat_timeval (i
> > guess).
> >
> > find the error message and the config attached.
>
> It's not even a randconfig issue, my build dies too (this is Linus's
> current tree.)
>
> Time to poke through the 10 bluetooth patches that were just added...
>
> thanks,
>
> greg k-h

that structure is undefined because that source file includes
<linux/compat.h>, which turns around and includes <asm/compat.h>
which, for i386, doesn't exist:

$ find include -name compat.h
include/asm-ia64/compat.h
include/config/video/v4l1/compat.h
include/config/sonypi/compat.h
include/asm-s390/compat.h
include/asm-mips/compat.h
include/linux/compat.h
include/asm-parisc/compat.h
include/asm-sparc64/compat.h
include/asm-x86_64/compat.h
include/asm-powerpc/compat.h
include/net/compat.h

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
