Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZIOTOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZIOTOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbZIOTOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:14:38 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59753 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395AbZIOTOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NcjW8gXbzl1euPWbRWqXlgZUHsOy7bJqCDq2d8tbv2Qj3rMG/2Xenlhg5mFeqy7ffm
         UwWYuRZ3gxJWd/oyJV91qWdMRq7BuIT/cFSCT/PEos7zQ017ZYVFzeHpNBjmkhQ+GhVt
         MPxRxIvUGYQRNq55CPfg1EfYT0ZKVMDPdpc3M=
Message-ID: <4AAFE78B.6060606@gmail.com>
Date: Tue, 15 Sep 2009 21:14:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com
Subject: Re: V4L2 drivers: potentially dangerous and inefficient msecs_to_jiffies()
 calculation
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
In-Reply-To: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr pisze:
> Hi all,
> 
> ./drivers/media/video/sn9c102/sn9c102_core.c
> ,
> ./drivers/media/video/et61x251/et61x251_core.c
> and
> ./drivers/media/video/zc0301/zc0301_core.c
> do
>                             cam->module_param.frame_timeout *
>                             1000 * msecs_to_jiffies(1) );
> multiple times each.
> What they should do instead is
> frame_timeout * msecs_to_jiffies(1000), I'd think.

Or better: frame_timeout * HZ

Marcin
