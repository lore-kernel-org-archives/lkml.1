Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYAEQAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYAEQAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYAEP76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:59:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:7044 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYAEP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=v8l4iiTZ2Vxij3aOSMnG1Dmx9YJ9olEa2AXqCZLXj+CGE7xVUWYNnYlh3uLrgn2UE86oFB76kTEOIRSKlWqu+ev7XJvLwkBJt+0/qK0iWjDsC0uHzceddYdGr+95q24msBhYw2tGHQHoIFae05UZpmAseYTVFSVdpPQrS5msD/M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 09/10] ide-floppy: use test_bit wrappers for testing flags
Date: Sat, 5 Jan 2008 17:10:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-10-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-10-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801051710.58924.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are two issues here:

* set_bit()/test_bit() are atomic operations and they don't see to be
  necessary in case of ide-floppy.c (standard '|'/'&' should be enough)

* using wrappers for these operations is not a bad idea but doing it _now_
  just makes it harder for us to figure out how to introduced common ATA
  Packet command interface for all ATAPI device drivers (the other drivers
  are using very similar flag handling and flag names currently)

so I would say that we should defer introducting these wrappers for now
(patch converting set_bit()/test_bit() to '|'/'&' would still be welcomed).

On Thursday 03 January 2008, Borislav Petkov wrote:
> also, fix header comments and remove superfluous ones. There should be no
> functionality change resulting from this patch.

fixes for comments look fine but they should be merged with the other
patch (the one containing checkpatch.pl/comments fixes)

Thanks,
Bart
