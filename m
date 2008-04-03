Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbYDCNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbYDCNk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYDCNkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:40:14 -0400
Received: from nn7.de ([85.214.94.156]:54490 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbYDCNkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:40:13 -0400
Subject: Re: 2.6.25-rc8: WARNING: at net/ipv4/tcp_input.c:2173
	tcp_mark_head_lost+0x11d/0x150()
From: Soeren Sonnenburg <kernel@nn7.de>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804031616330.21524@wrl-59.cs.helsinki.fi>
References: <1207199456.7616.3.camel@localhost>
	 <Pine.LNX.4.64.0804031616330.21524@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Apr 2008 15:40:08 +0200
Message-Id: <1207230008.4513.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 16:26 +0300, Ilpo Järvinen wrote:
> On Thu, 3 Apr 2008, Soeren Sonnenburg wrote:
> 
> > trying to download things, I am seeing this (ignore the tainted, it is
> > from madwifi and although the module is loaded the device was never
> > used)
> > 
> > Could anyone make sense of this please?
> 
> ...I'm just trying to find out who and where invariants of the TCP code
> are broken. These were relatively recently enabled (pre-2.6.24 just didn't 
> care too much). A number of long standing issues plus bugs from my 
> modifications have been fixed because of the more rigid checking :-).
> 
> > ------------[ cut here ]------------
> > WARNING: at net/ipv4/tcp_input.c:2173 tcp_mark_head_lost+0x11d/0x150()
> 
> > ------------[ cut here ]------------
> > WARNING: at net/ipv4/tcp_input.c:1771 tcp_enter_frto+0x267/0x270()
> 
> > ------------[ cut here ]------------
> > WARNING: at net/ipv4/tcp_input.c:2532 tcp_ack+0x1a6f/0x1d60()
> 
> Can you reproduce it? 

Yes, by massively downloading things :-) But I have no real recipe to
make it easily reproducible...

Looks like you are in fact interested in:
grep WARNING: /var/log/kern.log | cut -c 40- | sort -u

net/ipv4/tcp_input.c:1771 tcp_enter_frto+0x267/0x270()
net/ipv4/tcp_input.c:2173 tcp_mark_head_lost+0x11d/0x150()
net/ipv4/tcp_input.c:2532 tcp_ack+0x1a6f/0x1d60()
net/ipv4/tcp_input.c:3067 tcp_ack+0x1d2b/0x1d60()

> Please include netdev next time while report networking related problems.

OK
Soeren
