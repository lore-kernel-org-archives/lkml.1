Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZHPCPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZHPCPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 22:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZHPCPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 22:15:35 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:59287 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZHPCPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 22:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=scyMmkMC5YE42VxIzRu8d11z6RzsdCqb/Nr3EC6P2tHCEnJZt02ga8doVKyLGl09lD
         n31VnGXN+fZQaPxSrRmMekwVtzbk+PDNcn0rn6OA2Cxko1EgFWfOsJCmZf1PdPTUSTCq
         kH+kYmNKNbiclA+SqJfunElBk66Z//CnFKclU=
Message-ID: <4A876BC3.3020407@gmail.com>
Date: Sun, 16 Aug 2009 11:15:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ata_tf_read_block() question
References: <20090815.224843.240484147.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090815.224843.240484147.anemo@mba.ocn.ne.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Atsushi.

Atsushi Nemoto wrote:
> I have a question on CHS calculation in ata_tf_read_block().
> 
> The calculation in ata_tf_read_block() is:
> 	block = (cyl * dev->heads + head) * dev->sectors + sect;
> 
> but ata_build_rw_tf() does:
> 	track = (u32)block / dev->sectors;
> 	cyl   = track / dev->heads;
> 	head  = track % dev->heads;
> 	sect  = (u32)block % dev->sectors + 1;
> 
> It seems inconsistent.  The correct calculation is:
> 	block = (cyl * dev->heads + head) * dev->sectors + sect - 1;
> isn't it?

Yes, indeed.

> I don't have any real problem.  Just noticed by code reading.

ata_tf_read_block() currently is used only when reporting failed block
address to upper layer so off-by-one bug there wouldn't be too
visible, especially for the venerable CHS addressing.

Care to submit a patch w/ warning message and capping for sect == 0
case?

Thanks.

-- 
tejun
