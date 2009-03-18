Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZCRGFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZCRGFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZCRGFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:05:08 -0400
Received: from verein.lst.de ([213.95.11.210]:45020 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZCRGFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:05:08 -0400
Date: Wed, 18 Mar 2009 07:04:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: VIRTIO_BLK_T_SCSI_CMD in the virtio-blk protocol
Message-ID: <20090318060453.GA10650@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when virtio-blk gets a packet command request it just sets
the VIRTIO_BLK_T_SCSI_CMD flag in the type field, a zero sector and
sends down the request payload.

However for packet command requests they payload doesn't really say
anything about the command, we could need the cmd array to specify what
command (and offset/length) we're actually sending.

As far as I can see none of the backends actually implements
VIRTIO_BLK_T_SCSI_CMD support, so no harm is done here.

Should we just remove all handling of this flag until we have proper
support for it?  That would most like mean sending down another S/G
sement with the scsi command before the actual data.

Btw, is there a protocol spec for virtio-blk somewhere?
