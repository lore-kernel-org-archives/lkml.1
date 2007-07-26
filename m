Return-Path: <linux-kernel-owner+w=401wt.eu-S936657AbXGZUtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936657AbXGZUtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932568AbXGZUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:48:56 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:37772 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764861AbXGZUsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:48:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: integer overflow in i2o_block
Date: Thu, 26 Jul 2007 16:48:39 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B32D@otce2k301.adaptec.com>
In-Reply-To: <Pine.SOC.4.64.0707262322240.7082@math.ut.ee>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: integer overflow in i2o_block
Thread-Index: AcfPw/wGLpEqRUdESVK3YnG3++bwswAAkg9w
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Meelis Roos" <mroos@linux.ee>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I would change tid from an int to an unsigned instead, he is the culprit
that is promoting the unsigned to an signed.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Meelis Roos
> Sent: Thursday, July 26, 2007 4:30 PM
> To: Linux Kernel list
> Subject: integer overflow in i2o_block
> 
> 
> Got this warning on 32-bit ppc, seems real? And it seems I2O 
> subsystem has no maintainer (only DPT_I2O has one)?
> 
>   CC [M]  drivers/message/i2o/i2o_block.o
> drivers/message/i2o/i2o_block.c: In function 'i2o_block_transfer':
> drivers/message/i2o/i2o_block.c:837: warning: integer 
> overflow in expression
> 
> The line in question is
> msg->u.head[1] = cpu_to_le32(I2O_CMD_PRIVATE << 24 | HOST_TID 
> << 12 | tid);
> and I2O_CMD_PRIVATE is defined as 0xFF. This gets "0xFF0100 | 
> tid" and 
> fits into 32-bit unsigned but not into 32-bit signed integer properly.
> Target value head[*] is defined as u32 so the claculation 
> does not fit 
> during computation? Should we mark the shiftable inputas as unsigned?
> 
> -- 
> Meelis Roos (mroos@linux.ee)
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
