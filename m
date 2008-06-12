Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbYFLOSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbYFLOSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbYFLOSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:18:33 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42261 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909AbYFLOSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:18:31 -0400
Subject: Re: Prevent busy looping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48512801.7090502@gmail.com>
References: <20080416151305.8788.63912.stgit@denkblock.local>
	 <20080416163152.GK12774@kernel.dk> <87r6d5l9pb.fsf@denkblock.local>
	 <20080417071335.GR12774@kernel.dk> <87ve2gc1bn.fsf@denkblock.local>
	 <484F7A8D.1040809@gmail.com> <20080611080502.4aa43980@core>
	 <484F86D4.8050907@gmail.com> <485092C9.3050309@gmail.com>
	 <87d4mmubvf.fsf@denkblock.local>  <48512801.7090502@gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 09:18:27 -0500
Message-Id: <1213280307.3426.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 22:43 +0900, Tejun Heo wrote:
> It busy loops but it won't lock up as command completion is the loop
> breaker and command completion comes via IRQ and the busy looping
> doesn't happen solely in the IRQ context.  Still needs to be fixed tho.
>  Anyways, this is only limited to ->qc_defer for simplex and the reason
> why there's busy loop is because we're trying to schedule two
> independent hosts and SCSI midlayer (of course) doesn't have the notion
> of cross host deferring.

It would if the host were at the right level.  We have the whole concept
of starved list processing for blocked queues that was supposed to be
designed for this (well, for a corresponding SCSI situation).

James


