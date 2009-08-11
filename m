Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbZHKL4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbZHKL4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZHKL4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:56:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:37436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbZHKLyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:33 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH-v3 0/2] delay initializing queue for request-based dm
Date: Tue, 11 Aug 2009 15:02:30 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
References: <200908081025.54154.knikanth@suse.de> <200908101618.12508.knikanth@suse.de>
In-Reply-To: <200908101618.12508.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111502.31215.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009 16:18:12 Nikanth Karthikesan wrote:
> On Saturday 08 August 2009 10:25:53 Nikanth Karthikesan wrote:
> > Hi
> >
> > Currently for device-mapper devices, we initialize the mempool for
> > requests and elevator at device creation time. But only request-based
> > devices use the elevator and mempool. These patches change it to allocate
> > the mempool and initialize the elevator only for request-based devices.
> > This is done by allocating a queue at device creation time, but delaying
> > the initialization of elevator and allocation of mempool till the first
> > table load time, when the type of device would be known.
> >
> > [PATCH 1/2] Allow delaying initialization of queue after allocation
> >
> > [PATCH 2/2] Initialize mempool and elevator only for request-based dm
> > devices
> >
> > Another approach would be to free the mempool and detach elevator, if it
> > would be a bio-based device. But it is better to avoid initialization
> > itself.
>
> Changes since v1:
> 1. Refreshed on top of a4e7d46407d73f35d217013b363b79a8f8eafcaa
> 2. Added comments suggested by Mike Snitzer.
> 3. Cleaned up the second patch as suggested by Mike Snitzer.
>

Changes since v2:
1. Add comments suggested by Kiyoshi Ueda
2. Export symbol elv_register_queue() to modules.
3. Call elv_register_queue() after initializing the queue to use the elevator.

Thanks
Nikanth

