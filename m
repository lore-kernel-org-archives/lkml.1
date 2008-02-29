Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYB2Efq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYB2Efq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbYB2Efa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:35:30 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:38951 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642AbYB2Ef3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:35:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=lB0B7qgzWF5zszQUlNT0zBGmhMof8oWnN5GJUZ6GxR/2Eqhu//gz8AZPyjW/XvMO;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Thu, 28 Feb 2008 23:35:14 -0500
From: Bill Fink <billfink@mindspring.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Ilpo =?ISO-8859-1?Q?J=E4rvinen" ?= <ilpo.jarvinen@helsinki.fi>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Giangiacomo Mariotti <giangiacomo_mariotti@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2054 tcp_mark_head_lost()
Message-Id: <20080228233514.63b7136e.billfink@mindspring.com>
In-Reply-To: <20080228171011.fc56eace.akpm@linux-foundation.org>
References: <858077.97160.qm@web39709.mail.mud.yahoo.com>
	<20080223000310.4630daa8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802271108290.13029@kivilampi-30.cs.helsinki.fi>
	<3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com>
	<Pine.LNX.4.64.0802272120430.1741@kivilampi-30.cs.helsinki.fi>
	<Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
	<20080228171011.fc56eace.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d88cf07df2e3b47a2fcd11fcbd178242a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.55.21.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Andrew Morton wrote:

> On Thu, 28 Feb 2008 10:22:27 +0200 (EET) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> 
> > [PATCH] TCP debug S+L (for 2.6.25-rcs, incompatible with 2.6.24.y)
> > 
> > ---
> >  include/net/tcp.h     |    9 +++-
> >  net/ipv4/tcp_input.c  |   18 +++++++-
> >  net/ipv4/tcp_ipv4.c   |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  net/ipv4/tcp_output.c |   23 +++++++--
> 
> I'll put this in -mm, see if we can flush anything out.  Please let me know
> if/when it's obsolete, updated, etc.
> 
> What is "S+L"?

I'll let Ilpo give the definitive answer.  But to test if I'm starting
to grasp this, I'll give my understanding.  I believe 'S' means that a
transmitted TCP skb has been acknowledged by a SACK, while 'L' means
that a transmitted SKB is believed lost.  Since the 'S' state implies
that the packet has actually been successfully received, it should not be
possible for it to be considered lost ('L' state).  Thus an "S+L" state
for a TCP skb is an internally inconsistent state and an indication of
a TCP bug.

Anyone feel free to correct me if I'm way off base in my understanding.

						-Bill
