Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZDXLBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZDXLBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZDXLAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:00:49 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57231 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZDXLAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:00:48 -0400
Message-ID: <49F19BE1.6030104@s5r6.in-berlin.de>
Date: Fri, 24 Apr 2009 13:00:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
References: <20090422090929.GA14928@havoc.gtf.org> <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
In-Reply-To: <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> Data Center
> environments (not just Google's) like to track disks in many different
> ways, including the SCSI identifiers since this one "key" for physical
> location. Breaking the current mappings is going to cause some people
> a world of pain

If by SCSI identifiers you mean the Linux SCSI core's h:c:i:l, then
remember that these are scsi-core internal artifacts without any meaning
to lower and upper layers whatsoever, including userspace.  (Exception:
 The c:i:l part has some significance with SCSI Parallel Interface
attached hardware.)

> since they will need to manually build (and integrate)
> old->new maps of the SCSI identifiers.

Stock udev already provides mapping according to actually useful
identifiers (if the respective transport provides them: persistent and
unique identifiers of targets and logical units).
-- 
Stefan Richter
-=====-==--= -=-- ==---
http://arcgraph.de/sr/
