Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbXFMA0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbXFMA0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbXFMA0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:26:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbXFMA0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:26:31 -0400
Date: Wed, 13 Jun 2007 01:26:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix empty macros in acpi.
Message-ID: <20070613002631.GL21478@ftp.linux.org.uk>
References: <20070612233309.GA24251@redhat.com> <20070613000029.GK21478@ftp.linux.org.uk> <20070613002115.GA28778@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613002115.GA28778@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 08:21:15PM -0400, Dave Jones wrote:
> On Wed, Jun 13, 2007 at 01:00:29AM +0100, Al Viro wrote:
>  > On Tue, Jun 12, 2007 at 07:33:09PM -0400, Dave Jones wrote:
>  > > +#define DBG(x...) do { } while(0)
>  > 
>  > Eh...  Please, stop it - if you want a function-call-like no-op returning void,
>  > use ((void)0).  At least that way one can say DBG(....),foo(), etc.
> 
> They both end up compiled to nothing anyway, so I'm not bothered
> either way..   I'm not sure I follow why the syntax of that last part
> is a good thing.  It looks like something we'd want to avoid rather
> than promote?

If on one side of ifdef it's a void-valued expression, so it should be
on another; the reason is that we don't get surprise differences between
the builds...

IOW, if it doesn't build in some context, it should consistently fail to
build in that context.
