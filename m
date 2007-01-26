Return-Path: <linux-kernel-owner+w=401wt.eu-S1030697AbXAZBVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030697AbXAZBVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030695AbXAZBVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:21:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41553 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030559AbXAZBVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:21:12 -0500
Message-ID: <45B9577D.9000302@garzik.org>
Date: Thu, 25 Jan 2007 20:21:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ed Lin <ed.lin@promise.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       David Somayajulu <david.somayajulu@qlogic.com>,
       Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "james.Bottomley" <james.Bottomley@SteelEye.com>,
       Promise_Linux <Promise_Linux@promise.com>
Subject: Re: [patch] scsi: use lock per host instead of per device for shared
 queue tag host
References: <B70A50D07063384EB9BCE3330D18414F02F5B011@nonameb.ptu.promise.com>
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F02F5B011@nonameb.ptu.promise.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Lin wrote:
> There may possibly be some other errors. So we need a lock here.
> I think the simple but reliable way to do it is just to replace
> queue lock with a host lock. James pointed out that there may be
> performance slow down when many devices are accessed at the
> same time. But I think the major part is still on the hardware,
> and a host lock is the price these kind of controllers must pay.


I agree.

Further, a host lock is (a) common across many controllers, to protect 
host-wide resources and (b) only limits us when the controller is 
CPU-limited, a very rare scenario.

	Jeff


