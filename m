Return-Path: <linux-kernel-owner+w=401wt.eu-S1767813AbXDFP4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767813AbXDFP4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767811AbXDFP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:56:44 -0400
Received: from dsl-63-249-106-23.cruzio.com ([63.249.106.23]:55574 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767792AbXDFP4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:56:43 -0400
Date: Fri, 6 Apr 2007 08:51:32 -0700
From: Andrew Burgess <aab@cichlid.com>
Message-Id: <200704061551.l36FpWoV015751@cichlid.com>
To: james.bottomley@steeleye.com
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Cc: cebbert@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, aradford@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:

>It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
>assumes request sense is always the use_sg == 0 case.  This is what it
>does on a request sense:

>static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
>{
>        dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");

>        /* For now we just zero the request buffer */
>        memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
>        tw_dev->state[request_id] = TW_S_COMPLETED;
>        tw_state_request_finish(tw_dev, request_id);
>....

>Note that it's clearing the request buffer, which is actually zeroing the scatterlist, hence the problem.

OK. Is there a quick workaround or should I just wait for
Adam & Company to make a patch?

You said your earlier patch would hide it, and then said you
had a length wrong in it and I'm not sure what length you
mean.

Thanks for yours and Chuck's and Dave's time.

