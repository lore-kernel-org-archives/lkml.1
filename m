Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYFXCqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYFXCqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYFXCqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:46:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:45746 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYFXCqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:46:05 -0400
Date: Tue, 24 Jun 2008 11:45:35 +0900
To: david.altobelli@hp.com
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Subject: Re: [PATCH][resubmit] HP iLO driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080623160052.GA7616@ldl.fc.hp.com>
References: <20080623160052.GA7616@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080624114527U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 10:00:52 -0600
David Altobelli <david.altobelli@hp.com> wrote:

> A driver for the HP iLO/iLO2 management processor, which allows userspace
> programs to query the management processor.  Programs can open a channel
> to the device (/dev/hpilo/dXccbN), and use this to send/receive queries.  
> The O_EXCL open flag is used to indicate that a particular channel cannot
> be shared between processes.  This driver will replace various packages
> HP has shipped, including hprsm and hp-ilo.

This driver creates the own device file and user-space applications
write a request data to the device file and read the response from it?

Would it be better to use the existing infrastructure (block/bsg.c) to
do that? With bsg, you don't need to invent your fifo code to enqueue
and dequeue requests.
