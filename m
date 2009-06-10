Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZFJGxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZFJGxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZFJGxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:53:43 -0400
Received: from wsip-70-184-212-11.om.om.cox.net ([70.184.212.11]:59579 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZFJGxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:53:42 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: Mike Galbraith <gleep@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pty tcdrain() bug in 2.6.27 to 2.6.30/current
Date: Wed, 10 Jun 2009 01:53:20 -0500
User-Agent: KMail/1.11.3 (Linux/2.6.27-gentoo-r7; KDE/4.2.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200906092338.42368.luke@dashjr.org> <1244615954.19735.42.camel@marge.simson.net>
In-Reply-To: <1244615954.19735.42.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906100153.38925.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009 01:39:14 am Mike Galbraith wrote:
> On Tue, 2009-06-09 at 23:38 -0500, Luke-Jr wrote:
> > tcdrain blocks on ptys since 2.6.27; at least 2.6.26 returns in a timely
> > manner. The following test case reproduces the bug, and hangs only on
> > affected kernels. Examination of 2.6.26 and 2.6.27 suggests the ioctl
> > used by tcdrain underwent a rewrite for 2.6.27, and thus fixing this bug
> > is beyond my capabilities at this time.
>
> It looks to me like it's doing what it should do, and any bug would be
> in kernels before the break handling (by Alan Cox, CC'd) rework.
>
> Disclaimer:  My knowledge wrt tty IO approaches 0, but since I burned a
> bit of time rummaging, you get one absolutely free reply.

My knowledge on how it *should* work also approaches 0, but I am unfortunately 
faced with a proprietary (user-space) blob GPS driver (which never reads its 
NMEA-providing pty) that relies on this behaviour (or gpsd not doing the 
tcdrain). However, the manual page for tcdrain says it waits until data is 
*trasmitted*, not necessarily received... Not sure if that makes a difference 
for this scenario?

Luke
