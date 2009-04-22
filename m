Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZDVNJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZDVNJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZDVNJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:09:11 -0400
Received: from rtr.ca ([76.10.145.34]:33068 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbZDVNJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:09:10 -0400
Message-ID: <49EF16F5.5080909@rtr.ca>
Date: Wed, 22 Apr 2009 09:09:09 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
References: <20090422090929.GA14928@havoc.gtf.org>
In-Reply-To: <20090422090929.GA14928@havoc.gtf.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Currently, libata creates a Scsi_Host per port.  This was originally
> done to leverage SCSI's infrastructure to arbitrate among master/slave
> devices, but is not needed for most modern SATA controllers.   And I
> _think_ it is not needed for master/slave if done properly, either.
> 
> The patch below converts libata such that there is now a 1:1
> correspondence between struct Scsi_Host and struct ata_host.  ATA ports
> are represented as SCSI layer 'channels', which is more natural.
> 
> This patch is an experiment, and not meant for upstream anytime soon.
..

Could you perhaps explain how error handling would behave in this scheme?

Currently, one SATA port can have failures without any impact whatsoever
on concurrent operation of other ports, in part because each port is treated
as a completely independent SCSI host.

I wonder if that changes with the new (better) scheme proposed here?

