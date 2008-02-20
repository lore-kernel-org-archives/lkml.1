Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbYBTIlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbYBTIlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762406AbYBTIl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:41:29 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:24324 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762335AbYBTIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dxxXqCZg/nHXUjIcz+bkMbf54VTGghSHPM0y0paAaBWtVTT4Q9AUylfSpUavkxuQxqY//hOenMa36ArdhNei7Y4NGsCO/f4wAu8d2pXnwtGkknO9RkHobGy2IR6umR8JwP+zjbmJIZES+SAQ2f1sER2h+iGzILImALfIDoR9AoA=
Message-ID: <e2e108260802200041p1c7ec428lf8b82b2017cce1b4@mail.gmail.com>
Date: Wed, 20 Feb 2008 09:41:24 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Erez Zilber" <erezz@voltaire.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47BBD7FA.9090101@Voltaire.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <47A89660.1080804@Voltaire.COM>
	 <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
	 <47B95343.9060802@Voltaire.COM>
	 <e2e108260802180301o5c376024t72e649a9debd5157@mail.gmail.com>
	 <47BBD7FA.9090101@Voltaire.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20, 2008 8:34 AM, Erez Zilber <erezz@voltaire.com> wrote:
> Bart Van Assche wrote:
> > Or: data sent during the first burst is not transferred via one-sided
> > remote memory reads or writes but via two-sided send/receive
> > operations. At least on my setup, these operations are as fast as
> > one-sided remote memory reads or writes. As an example, I obtained the
> > following numbers on my setup (SDR 4x network);
> > ib_write_bw: 933 MB/s.
> > ib_read_bw: 905 MB/s.
> > ib_send_bw: 931 MB/s.
>
> According to these numbers one can think that you don't need RDMA at
> all, just send iSCSI PDUs over IB.

Sorry, but you are misinterpreting what I wrote.

> The benchmarks that you use are
> synthetic IB benchmarks that are not equivalent to iSCSI over iSER. They
> just send IB packets. I'm not surprised that you got more or less the
> same performance because, AFAIK, ib_send_bw doesn't copy data (unlike
> iSCSI that has to copy data that is sent/received without RDMA).

I agree that ib_write_bw / ib_read_bw / ib_send_bw performance results
are not equivalent to iSCSI over iSER. The reason that I included
these performance results was to illustrate that two-sided data
transfers over IB are about as fast as one-sided data transfers.

> When you use RDMA with iSCSI (i.e. iSER), you don't need to create iSCSI
> PDUs and process them. The CPU is not busy as it is with iSCSI over TCP
> because no data copies are required. Another advantage is that you don't
> need header/data digest because the IB HW does that.

As far as I know, when using iSER, the FirstBurstLength bytes of data
are sent via two-sided data transfers, and there is no CPU
intervention required to transfer the data itself over the IB network.

Bart Van Assche.
