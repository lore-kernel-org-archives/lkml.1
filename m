Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZGTVZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZGTVZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZGTVZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:25:50 -0400
Received: from mail.vyatta.com ([76.74.103.46]:45121 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZGTVZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:25:48 -0400
Date: Mon, 20 Jul 2009 14:25:42 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: serue@us.ibm.com
Cc: David Miller <davem@davemloft.net>, containers@lists.osdl.org,
       sachinp@in.ibm.com, netdev@vger.kernel.org, matthltc@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] veth: don't free priv->status until dev->destructor
 (v2)
Message-ID: <20090720142542.4fb12c12@nehalam>
In-Reply-To: <20090715.085012.223420354.davem@davemloft.net>
References: <20090626162418.GA24828@us.ibm.com>
	<20090715.085012.223420354.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 08:50:12 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: "Serge E. Hallyn" <serue@us.ibm.com>
> Date: Fri, 26 Jun 2009 11:24:18 -0500
> 
> > I haven't been able to reproduce the original oops though (been
> > trying to cat the stats sysfs files while rmmoding veth, to no
> > avail, and haven't found an original bug report or testcase), so
> > can't verify whether this patch prevents the original oops.
> 
> If you 'cat' it you're unlikely to trigger the oops.
> 
> You have to hold the sysfs files open, and then elsewhere do the
> rmmod, wait, and then continue with some access to those open sysfs
> file descriptors (f.e. do some reads).
> 
> I'd also need this patch to be against current sources as they'll
> never apply since I did the revert quite some time ago.
> 
> Thanks.


My usual way of doing this is:

#  (sleep 30; cat /sys/class/net/ethX/statistics/tx_bytes) &
# rmmod the_buggy_driver

wait...


-- 
