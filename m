Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXCaRly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXCaRly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXCaRly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:41:54 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbXCaRlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:41:53 -0400
Date: Sat, 31 Mar 2007 10:41:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Ken Chen <kenchen@google.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] remove artificial software max_loop limit
Message-Id: <20070331104144.46c85f27.akpm@linux-foundation.org>
In-Reply-To: <20070331170743.GB14596@kroah.com>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
	<20070330141524.5f6cff29.akpm@linux-foundation.org>
	<20070331170743.GB14596@kroah.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 10:07:43 -0700 Greg KH <greg@kroah.com> wrote:

> On Fri, Mar 30, 2007 at 02:15:24PM -0700, Andrew Morton wrote:
> > On Fri, 30 Mar 2007 02:25:37 -0700
> > "Ken Chen" <kenchen@google.com> wrote:
> > 
> > > -module_param(max_loop, int, 0);
> > > -MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
> > 
> > So..  this change will cause a fatal error for anyone who is presently
> > using max_loop, won't it?  If they're doing that within their
> > initramfs/initrd/etc then things could get rather ugly for them.
> > 
> > I don't know how much of a problem this will be in practice - do people use
> > max_loop much?
> 
> Yes, the distros do, and they recommend it to their users a lot.

Thanks.  In that case I think we should retain the max_loop module parameter
for now.

Ken, when you respin that patch could you restore max_loop, and make its
use trigger a warning along the lines of "loop: the max_loop option is obsolete
and will be removed in March 2008"?
