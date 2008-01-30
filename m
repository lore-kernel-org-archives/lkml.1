Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYA3Wec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYA3Wec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYA3WeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:34:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907AbYA3WeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:34:19 -0500
Date: Wed, 30 Jan 2008 14:33:35 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: e1000 full-duplex TCP performance well below wire speed
Message-ID: <20080130143335.7fc9ea21@deepthought>
In-Reply-To: <Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
	<20080130.055333.192844925.davem@davemloft.net>
	<Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>
	<20080130082136.1017631d@deepthought>
	<Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 16:25:12 -0600 (CST)
Bruce Allen <ballen@gravity.phys.uwm.edu> wrote:

> Hi Stephen,
> 
> Thanks for your helpful reply and especially for the literature pointers.
> 
> >> Indeed, we are not asking to see 1000 Mb/s.  We'd be happy to see 900
> >> Mb/s.
> >>
> >> Netperf is trasmitting a large buffer in MTU-sized packets (min 1500
> >> bytes).  Since the acks are only about 60 bytes in size, they should be
> >> around 4% of the total traffic.  Hence we would not expect to see more
> >> than 960 Mb/s.
> 
> > Don't forget the network overhead: http://sd.wareonearth.com/~phil/net/overhead/
> > Max TCP Payload data rates over ethernet:
> >  (1500-40)/(38+1500) = 94.9285 %  IPv4, minimal headers
> >  (1500-52)/(38+1500) = 94.1482 %  IPv4, TCP timestamps
> 
> Yes.  If you look further down the page, you will see that with jumbo 
> frames (which we have also tried) on Gb/s ethernet the maximum throughput 
> is:
> 
>    (9000-20-20-12)/(9000+14+4+7+1+12)*1000000000/1000000 = 990.042 Mbps
> 
> We are very far from this number -- averaging perhaps 600 or 700 Mbps.
>


That is the upper bound of performance on a standard PCI bus (32 bit).
To go higher you need PCI-X or PCI-Express. Also make sure you are really
getting 64-bit PCI, because I have seen some e1000 PCI-X boards that
are only 32bit.
