Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZCRGJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZCRGJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZCRGJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:09:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZCRGJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:09:27 -0400
Date: Wed, 18 Mar 2009 02:09:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: VIRTIO_BLK_T_SCSI_CMD handling in virtio-blk
Message-ID: <20090318060919.GA21777@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently virtio-blk just sends down the payload for packet command
requests, setting the VIRTIO_BLK_T_SCSI_CMD flag in the type field and
zeroing out the sector field.

But to make any sense of the payload of a packet command we need the
scsi command block (request->cmd) which specifies the operation,
location and length for this command.

All backends that I checked just fail VIRTIO_BLK_T_SCSI_CMD commands, so
AFAICS no harm is done.  But should we really keep this broken support
in the protocol around?  If we do want to support packet commands in
the future we should probably just add the command as the first S/G list
entry.

Is there an actual protocol spec for virtio-blk somewhere to write these
subtilities down?  Or an list of implementations to check at least?
