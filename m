Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYBAJJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYBAJJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYBAJIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:08:39 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:63165 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbYBAJIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dX8lfqWdyIMq1qLuzX2eLmf/DYsg5qfP0M8maJbvbiOS7+UR0Fh+h8S2WzJJro9evSfKie7WtNSt9riJL+kijoKyv+M1bRKcRO0mbIOJc9LRaw+G5bRCWF5/6N3g7AKQUx6h5Vfr6mutXR3dke9S3dznq3dFeNsDrk8AaeS4CL8=
Message-ID: <e2e108260802010108h4595040aq236db9c6d0476571@mail.gmail.com>
Date: Fri, 1 Feb 2008 10:08:28 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>, "FUJITA Tomonori" <tomof@acm.org>,
       fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1201803339.11265.166.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
	 <47A1EE54.6000005@vlnb.net>
	 <1201799660.11265.121.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310940s5a6e963cva6c106a82388065f@mail.gmail.com>
	 <1201803339.11265.166.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 7:15 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>
> I meant small referring to storage on IB fabrics which has usually been
> in the research and national lab settings, with some other vendors
> offering IB as an alternative storage fabric for those who [w,c]ould not
> wait for 10 Gb/sec copper Ethernet and Direct Data Placement to come
> online.  These types of numbers compared to say traditional iSCSI, that
> is getting used all over the place these days in areas I won't bother
> listing here.

InfiniBand has several advantages over 10 Gbit/s Ethernet (the list
below probably isn't complete):
- Lower latency. Communication latency is not only determined by the
latency of a switch. The whole InfiniBand protocol stack was designed
with low latency in mind. Low latency is really important for database
software that accesses storage over a network.
- High-availability is implemented at the network layer. Suppose that
a group of servers has dual-port network interfaces and is
interconnected via a so-called dual star topology, With an InfiniBand
network, failover in case of a single failure (link or switch) is
handled without any operating system or application intervention. With
Ethernet, failover in case of a single failure must be handled either
by the operating system or by the application.
- You do not have to use iSER or SRP to use the bandwidth of an
InfiniBand network effectively. The SDP (Sockets Direct Protocol)
makes it possible that applications benefit from RDMA by using the
very classic IPv4 Berkeley sockets interface. An SDP implementation in
software is already available today via OFED. iperf reports 470 MB/s
on single-threaded tests and 975 MB/s for a performance test with two
threads on an SDR 4x InfiniBand network. These tests were performed
with the OFED 1.2.5.4 SDP implementation. It is possible that future
SDP implementations will perform even better. (Note: I could not yet
get iSCSI over SDP working.)

We should leave the choice of networking technology open -- both
Ethernet and InfiniBand have specific advantages.

See also:
InfiniBand Trade Association, InfiniBand Architecture Specification
Release 1.2.1, http://www.infinibandta.org/specs/register/publicspec/

Bart Van Assche.
