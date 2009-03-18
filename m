Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZCRJhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZCRJhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZCRJhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:37:21 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:55022 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZCRJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:37:19 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Hannes Reinecke <hare@suse.de>
Subject: Re: VIRTIO_BLK_T_SCSI_CMD handling in virtio-blk
Date: Wed, 18 Mar 2009 10:37:15 +0100
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org
References: <20090318060919.GA21777@infradead.org> <200903180947.36878.borntraeger@de.ibm.com> <49C0BBFB.5040605@suse.de>
In-Reply-To: <49C0BBFB.5040605@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200903181037.16043.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2I9bjqu005985

Am Wednesday 18 March 2009 10:16:43 schrieb Hannes Reinecke:> -Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â end_dequeued_request(vbr->req, uptodate);> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â if (blk_pc_request(vbr->req)) {> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â vbr->req->data_len = vbr->in_hdr.residual;> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â bytes = vbr->in_hdr.data_len;> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â vbr->req->sense_len = vbr->in_hdr.sense_len;> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â vbr->req->errors = vbr->in_hdr.status;> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â } else

I think we identified a bug in the old patch:http://kerneltrap.org/mailarchive/linux-kvm/2008/8/29/3127594http://kerneltrap.org/index.php?q=mailarchive/linux-kvm/2008/8/29/3128124
Is this fixup still valid? 
-		if (blk_pc_request(vbr->req)) {+		if (blk_pc_request(vbr->req) && len >= sizeof(vbr->in_hdr)) {
I forgot almost all details about the problem.
Christianÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
