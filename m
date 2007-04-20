Return-Path: <linux-kernel-owner+w=401wt.eu-S2993311AbXDTSP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993311AbXDTSP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993308AbXDTSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:15:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993307AbXDTSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:15:58 -0400
Date: Fri, 20 Apr 2007 11:15:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: mpm@selenic.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
Message-Id: <20070420111526.01ad7f4c.akpm@linux-foundation.org>
In-Reply-To: <46288D11.4000801@bx.jp.nec.com>
References: <462605DC.2080804@bx.jp.nec.com>
	<462609D1.50300@bx.jp.nec.com>
	<20070419210813.a599c54f.akpm@linux-foundation.org>
	<46288D11.4000801@bx.jp.nec.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 18:51:13 +0900
Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:

> > I started to do some cleanups and fixups here, but abandoned it when it was
> > all getting a bit large.
> > 
> > Here are some fixes against this patch:
> 
> I'm going to fix my patches by following your reviews and send new patches 
> on the LKML and the netdev ML in a few days.
> 

Well..  before you can finish this work we need to decide upon what the
interface to userspace will be.

- The miscdev isn't appropriate

- netlink remains a possibility

- Stephen suggests an ioctl against a socket and davem suggests socket
  options, but it's unclear to me how that socket will get bound to
  netconsole?


either way, I agree with the overall thrust of this work: netconsole is
useful in production environments, can become more useful and will need
runtime configurability.


I wonder if we're approaching this in the right way, however...

At a high level, netconsole is just a flow of UDP packets between two
machines.  The kernel already has rich and well-understood ways of creating
and configuring such flows.

So...  instead of creating a brand new way of configuring such a flow via
sysfs and ioctl, could we instead create a flow using the existing
mechanisms (presumably the socket API) and then "transfer" the information
from that flow over to netconsole by some means??
