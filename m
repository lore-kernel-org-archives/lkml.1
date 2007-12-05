Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXLEXPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXLEXPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXLEXOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:14:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:48878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbXLEXOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:14:53 -0500
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 6 Dec 2007 10:14:47 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18263.12519.894142.682323@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is BIO_RW_FAILFAST really usable?
In-Reply-To: message from Jens Axboe on Tuesday December 4
References: <18260.49019.684445.303719@notabene.brown>
	<20071204091334.GG23294@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday December 4, jens.axboe@oracle.com wrote:
> 
> Hrmpf. It looks like the SCSI layer is a little too trigger happy. Any
> chance you could try and trace where this happens?

in scsi_lib.c, in scsi_request_fn, near the top of the main
   while (!blk_queue_plugged(q)) {
loop:

		if (!scsi_dev_queue_ready(q, sdev)) {
			if ((req->cmd_flags & REQ_FAILFAST) &&
			    !(req->cmd_flags & REQ_PREEMPT)) {
				scsi_kill_request(req, q);
				continue;
			}
			break;
		}

If I remove the "if failfast and not preempt then kill" logic, my
problem goes away.

NeilBrown
