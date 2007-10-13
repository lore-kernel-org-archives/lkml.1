Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbXJMXYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbXJMXYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 19:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbXJMXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 19:24:24 -0400
Received: from main.gmane.org ([80.91.229.2]:54060 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXJMXYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 19:24:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: regression(?): starting with 2.6.21 sending packets became
 broken.
Date: Sat, 13 Oct 2007 16:23:24 -0700
Organization: Linux Foundation
Message-ID: <20071013162324.7c140a61@freepuppy.rosehill>
References: <1192299385.31908.8.camel@localhost>
	<4711159D.1010305@unsolicited.net>
	<Pine.LNX.4.64.0710132233000.3348@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <Pine.LNX.4.64.0710132233000.3348@fbirervta.pbzchgretzou.qr>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 22:35:25 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Oct 13 2007 19:59, David wrote:
> >Try
> >
> >echo 0 > /proc/sys/net/ipv4/tcp_window_scaling
> >
> >I bet you have broken router(s) between your machine and the problem
> >site(s).
> 
> There is an xt_TCPOPTSTRIP module in the works that allows you to strip
> Window Scaling only on the connections you want (rather than globally);
> seems to be in for 2.6.24 at earliest, though it's there is also the 
> standalone patch.

You can also do it on a per route basis which is easier than bothering
with filtering rules by just enforcing a window size limit.

	ip route add {broken_dst}/32 via {gateway} window 65535


Long description at:
	http://lwn.net/Articles/92727/

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

