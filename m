Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbXELBER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbXELBER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXELBEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:04:10 -0400
Received: from squawk.glines.org ([72.36.206.66]:53143 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbXELBEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:04:09 -0400
Date: Fri, 11 May 2007 18:03:58 -0700
From: Mark Glines <mark@glines.org>
To: David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
Message-ID: <20070511180358.0ead2227@chirp>
In-Reply-To: <fa.IaUwa4kCMzO0RD0lNwacYsRlgXk@ifi.uio.no>
References: <fa.6ICeqRTz5I23Pq+Z0ov/n8wicZE@ifi.uio.no>
	<fa.IaUwa4kCMzO0RD0lNwacYsRlgXk@ifi.uio.no>
Organization: Glines.org
X-Mailer: Claws Mail 2.9.0 (GTK+ 2.10.12; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 00:06:45 UTC
David Miller <davem@davemloft.net> wrote:
> All ports above and including 1024 are non-privileged and available to
> anyone.
> 
> Applications which have some requirements in this area need to work
> those things out themselves.

Hi David,

I agree completely.  My issue is that an application which doesn't care
which port it binds to (twistd, on klive's behalf) stomped on the port
of an application which cares very much about which port it binds to
(nfs).  I will gladly accept *any* solution to this problem.

I agree that it would be preferable to change the port NFS decides to
bind to.  If you have a patch to do this, I will happily apply it and
go on my merry way.

However, the world we live in does have port numbers exceeding 1024
listed in /etc/services.  What I'd like to know is, for applications
which don't care what port they get, the kernel will assign values of
32768 and above on some machines, but not others. (Based on their bind
hash size.)  Starting from 32768 seems like very sane behavior to me,
because it minimizes the chances of a collision, and (as far as I know)
doesn't cost anything.  A configuration which stomps on a
not-entirely-unknown application like nfs *by default* isn't
necessarily a bug, but it is a worst case scenario, from the
perspective of a lowly user like me, who wants things to Just Work. :)

Is there a compelling reason not to assign random ports starting from
32768 everywhere regardless of their bind hash size, like my patch
attempts to do?  Does it consume any extra resources to do so?

Thanks,

Mark
