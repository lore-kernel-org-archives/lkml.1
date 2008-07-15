Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbYGOClq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbYGOClq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbYGOClW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:41:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:44245 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762251AbYGOClV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:41:21 -0400
Date: Tue, 15 Jul 2008 11:40:45 +0900
To: mpatocka@redhat.com
Cc: davem@davemloft.net, andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807140805380.10106@devserv.devel.redhat.com>
	<20080714.052859.88212003.davem@davemloft.net>
	<Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080715113238U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 10:03:29 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Mon, 14 Jul 2008, David Miller wrote:
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Date: Mon, 14 Jul 2008 08:16:13 -0400 (EDT)
> >
> >> As you mentioned ESP driver, it declares .sg_tablesize = SG_ALL, so
> >> BIO_VMERGE_BOUNDARY has no effect on the operation of this driver. Any
> >> other driver where BIO_VMERGE_BOUNDARY does matter?
> >
> > When BIO_VMERGE_BOUNDARY is turned on, requests that would not
> > otherwise fit into the device's limits, can.
> 
> Why would someone want to overshoot SG_ALL? ... and, shouldn't the 
> constant be increased then --- instead of making buggy BIO_VMERGE_BOUNDARY 
> expectations?

'buggy' is a wrong word. VMERGE works for some IOMMUs (though I think
that we need to fix it about max_segment_size).
