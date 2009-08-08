Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbZHHEyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbZHHEyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 00:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZHHEyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 00:54:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:56145 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZHHEyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 00:54:37 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 0/2] delay initializing queue for request-based dm
Date: Sat, 8 Aug 2009 10:25:53 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Hannes Reinecke <hare@suse.de>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081025.54154.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Currently for device-mapper devices, we initialize the mempool for requests 
and elevator at device creation time. But only request-based devices use the 
elevator and mempool. These patches change it to allocate the mempool and 
initialize the elevator only for request-based devices. This is done by 
allocating a queue at device creation time, but delaying the initialization of 
elevator and allocation of mempool till the first table load time, when the 
type of device would be known.

[PATCH 1/2] Allow delaying initialization of queue after allocation

[PATCH 2/2] Initialize mempool and elevator only for request-based dm devices

Another approach would be to free the mempool and detach elevator, if it would 
be a bio-based device. But it is better to avoid initialization itself.

Thanks
Nikanth
