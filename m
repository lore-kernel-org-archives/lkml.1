Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYFXETs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYFXETs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYFXETj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:19:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:33094 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYFXETj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:19:39 -0400
Date: Tue, 24 Jun 2008 13:19:14 +0900
To: david.altobelli@hp.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       greg@kroah.com, James.Bottomley@HansenPartnership.com,
       jens.axboe@oracle.com
Subject: RE: [PATCH][resubmit] HP iLO driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <CF70AA892F109448AEA269483B3A983903B70747D1@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
	<20080624114527U.fujita.tomonori@lab.ntt.co.jp>
	<CF70AA892F109448AEA269483B3A983903B70747D1@G1W1215.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080624131858O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 03:40:33 +0000
"Altobelli, David" <david.altobelli@hp.com> wrote:

> > -----Original Message-----
> > From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> >
> > This driver creates the own device file and user-space applications
> > write a request data to the device file and read the response from it?
> 
> Yes, though I would include that the data for the read response is
> supplied by the management processor.

It works with bsg.

bsg is designed to enable user-space applications to send a request to
something in kernel and get the response. For example, bsg is used to
implement the user-space interface to send a request to SAS hardware
and get the response.


> > Would it be better to use the existing infrastructure (block/bsg.c) to
> > do that? With bsg, you don't need to invent your fifo code to enqueue
> > and dequeue requests.
> 
> I'm probably missing something, but I need that particular fifo code
> to manage the device queues.

Oops, I overlooked it. OK, even with bsg, the fifo code is necessary.
Probably bsg can make the driver simpler a bit.
