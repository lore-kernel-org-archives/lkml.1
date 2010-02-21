Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0BUGXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 01:23:43 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:47293 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab0BUGXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 01:23:41 -0500
X-Greylist: delayed 797 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 01:23:41 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=b5/02YBVHp4LKoXeyBQs5Rtf2achgn8Q/3lOM9cCTg02SZ31PspOpK7YlPCkiocj;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sun, 21 Feb 2010 01:10:21 -0500
From: Bill Fink <billfink@mindspring.com>
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: Cong Wang <amwang@redhat.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v5 0/3] net: reserve ports for applications
 using fixed port numbers
Message-Id: <20100221011021.948676c4.billfink@mindspring.com>
In-Reply-To: <201002201557.04427.opurdila@ixiacom.com>
References: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com>
	<4B7F993C.9000007@redhat.com>
	<201002201557.04427.opurdila@ixiacom.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d7c99d5827c3040b1c07ae92d3b29968b350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.127.147.254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, Octavian Purdila wrote:

> On Saturday 20 February 2010 10:11:40 you wrote:
> > Octavian Purdila wrote:
> > > This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports which
> > > allows users to reserve ports for third-party applications.
> > >
> > > The reserved ports will not be used by automatic port assignments
> > > (e.g. when calling connect() or bind() with port number 0). Explicit
> > > port allocation behavior is unchanged.
> > >
> > > Changes from the previous version:
> > > - switch the /proc entry format to coma separated list of range ports
> > > - treat -EFAULT just like any other error and acknowledge written values
> > > - use isdigit() in proc_get_ulong
> > >
> > > Octavian Purdila (3):
> > >   sysctl: refactor integer handling proc code
> > >   sysctl: add proc_do_large_bitmap
> > >   net: reserve ports for applications using fixed port numbers
> > 
> > Hi,
> > 
> > This version looks fine for me, but I need to give them a test, and
> > I will put feedbacks asap. Thanks for your work!
> > 
> > Still two things:
> > 
> > 1) bitops are always atomic on every arch, right? If yes, then ok.
> 
> AFAIK, yes.
> 
> > 2) I hope you could add some documentation to show the relations
> >     between ip_local_port_range and ip_local_reserved_ports.
> > 
> 
> How does this sound:
> 
> ip_local_reserved_ports - list of comma separated ranges
>         Specify the ports which are reserved for known third-party
>         applications. These ports will not be used by automatic port
>         assignments (e.g. when calling connect() or bind() with port
>         number 0). Explicit port allocation behavior is unchanged.
> 
>         The format used for both input and output is a comma separated
>         list of ranges (e.g. "1,2-4,10-10" for ports 1, 2, 3, 4 and
>         10). Writing to the file will clear all previously reserved
>         ports and update the current list with the one given in the
>         input.
> 
>         Note that ip_local_port_range and ip_local_port_range settings

Change second ip_local_port_range to ip_local_reserved_ports.

						-Bill



>         are independent and both are considered by the kernel when
>         determining which ports are available for automatic port
>         assignments.
> 
>         You can reserve ports which are not in the current
>         ip_local_port_range, e.g.:
> 
>         $ cat /proc/sys/net/ipv4/ip_local_port_range
>         32000   61000
>         $ cat /proc/sys/net/ipv4/ip_local_reserved_ports
>         8080,9148
> 
>         although this is redundant. However such a setting is useful
>         if later the port range is changed to a value that will
>         include the reserved ports.
