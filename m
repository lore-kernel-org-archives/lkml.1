Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZCRIrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZCRIrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZCRIrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:47:42 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:41484 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZCRIrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:47:42 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: VIRTIO_BLK_T_SCSI_CMD handling in virtio-blk
Date: Wed, 18 Mar 2009 09:47:36 +0100
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       hare@suse.de
References: <20090318060919.GA21777@infradead.org>
In-Reply-To: <20090318060919.GA21777@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903180947.36878.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 March 2009 07:09:19 schrieb Christoph Hellwig:
> Currently virtio-blk just sends down the payload for packet command
> requests, setting the VIRTIO_BLK_T_SCSI_CMD flag in the type field and
> zeroing out the sector field.
> 
> But to make any sense of the payload of a packet command we need the
> scsi command block (request->cmd) which specifies the operation,
> location and length for this command.
> 
> All backends that I checked just fail VIRTIO_BLK_T_SCSI_CMD commands, so
> AFAICS no harm is done.  But should we really keep this broken support
> in the protocol around?  If we do want to support packet commands in
> the future we should probably just add the command as the first S/G list
> entry.

Hannes did some implementation for SCSI command passthrough:
https://lists.linux-foundation.org/pipermail/virtualization/2008-August/011629.html

After some addon fix this was working pretty well. I dont know why Hannes never
pushed the final version upstream.

Christian
