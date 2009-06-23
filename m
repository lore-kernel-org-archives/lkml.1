Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZFWXTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZFWXTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbZFWXTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:19:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758969AbZFWXTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:19:14 -0400
Date: Tue, 23 Jun 2009 16:18:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090623161852.660cab78.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906231538280.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
	<20090623131239.711d9f83.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
	<20090623142511.c9068655.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com>
	<20090623144416.04c34268.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231538280.17001@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 15:49:53 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Tue, 23 Jun 2009, Andrew Morton wrote:
> 
> > On Tue, 23 Jun 2009 14:25:05 -0700 (PDT)
> > Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> > > On Tue, 23 Jun 2009, Andrew Morton wrote:
> > > 
> > > > That isn't for us to decide. Entire syscalls can be disabled in config.
> > > 
> > > That is not a well defined separate syscall though. It's a member/feature 
> > > of the aiocb.
> > 
> > I don't know what this means, really.
> 
> This is the struct iocb:
> 
> struct iocb {
> 	...
> 	u_int32_t       aio_resfd;
> };
> 
> And the only interface to access KAIO is io_submit().
> IMO the end user perceives the KAIO functionality as the full deployment 
> of the iocb struct and the io_submit() accessory.
> Can code not using eventfd work in (AIO && !EVENTFD) mode? Sure.
> It is a kinda confusing configuration from the end user POV IMO.

What's confusing about it?

Most programmers who are using AIO probably don't even know that the
eventd hookup is available.  And even if they did, they might not want
to use it, to remain compatible with older kernels.

I'm still not seeing any compelling reason for unconditionally adding
kernel text which some users don't need.

Maybe there is such a reason, and it hasn't yet been beaten into my
skull.  But I still think it should be done in a separate patch.  One
which comes with a full description of the reasons for the change, btw.
