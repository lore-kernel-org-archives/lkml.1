Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYA3QWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYA3QWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYA3QV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:21:59 -0500
Received: from main.gmane.org ([80.91.229.2]:33788 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYA3QV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:21:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
Date: Wed, 30 Jan 2008 08:21:36 -0800
Organization: Linux Foundation
Message-ID: <20080130082136.1017631d@deepthought>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
	<20080130.055333.192844925.davem@davemloft.net>
	<Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 75-175-36-100.ptld.qwest.net
In-Reply-To: <Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>
X-Newsreader: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 08:01:46 -0600 (CST)
Bruce Allen <ballen@gravity.phys.uwm.edu> wrote:

> Hi David,
> 
> Thanks for your note.
> 
> >> (The performance of a full duplex stream should be close to 1Gb/s in
> >> both directions.)
> >
> > This is not a reasonable expectation.
> >
> > ACKs take up space on the link in the opposite direction of the
> > transfer.
> >
> > So the link usage in the opposite direction of the transfer is
> > very far from zero.
> 
> Indeed, we are not asking to see 1000 Mb/s.  We'd be happy to see 900 
> Mb/s.
> 
> Netperf is trasmitting a large buffer in MTU-sized packets (min 1500 
> bytes).  Since the acks are only about 60 bytes in size, they should be 
> around 4% of the total traffic.  Hence we would not expect to see more 
> than 960 Mb/s.
> 
> We have run these same tests on older kernels (with Broadcomm NICS) and 
> gotten above 900 Mb/s full duplex.
> 
> Cheers,
>      Bru

Don't forget the network overhead: http://sd.wareonearth.com/~phil/net/overhead/
 Max TCP Payload data rates over ethernet:
  (1500-40)/(38+1500) = 94.9285 %  IPv4, minimal headers
  (1500-52)/(38+1500) = 94.1482 %  IPv4, TCP timestamps

I believe what you are seeing is an effect that occurs when using
cubic on links with no other idle traffic. With two flows at high speed,
the first flow consumes most of the router buffer and backs off gradually,
and the second flow is not very aggressive.  It has been discussed
back and forth between TCP researchers with no agreement, one side
says that it is unfairness and the other side says it is not a problem in
the real world because of the presence of background traffic.

See:
  http://www.hamilton.ie/net/pfldnet2007_cubic_final.pdf
  http://www.csc.ncsu.edu/faculty/rhee/Rebuttal-LSM-new.pdf
   

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>


