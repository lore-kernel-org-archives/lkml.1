Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZCNUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZCNUvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 16:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZCNUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 16:51:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:23799 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZCNUvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 16:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uE9G+AO8Lz0cpDDq7BAgV/1mz66i11u+MgJGOzycqp7CdHmGZ5VjGufVmaAlbSCUaQ
         WW0eKj1FvinXEJC8F/NuCWM96vTOr0Yqp7iVvTYwdcsZcQoea7MSh+6EKhHqD3oGz1ma
         h4Vgcu9PyD5hFKD/N7WEgZLUJyxizXWpTxV/o=
MIME-Version: 1.0
Date: Sat, 14 Mar 2009 13:51:36 -0700
Message-ID: <3aa654a40903141351y26f2e732t67dd1ac69651f909@mail.gmail.com>
Subject: Generic timeout warnings begin after v2.6.25 but before v2.6.26-rc1 
	[Was: DRDY ata message > 2.6.24.7-rt14, not before.]
From: Avuton Olrich <avuton@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 3:54 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> Avuton Olrich wrote:
>>
>> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> ata4.00: cmd 35/00:10:b0:70:75/00:00:1f:00:00/e0 tag 0 dma 8192 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>
>
> Since you are seeing generic timeouts, without additional information, I
> would guess either a problem with interrupt delivery (not uncommon in -rt
> kernels) or you need to force your drives to 1.5Gbps.
>
>        Jeff

OK, I have tried to bisect it (completely without -rt) and it breaks
completely somewhere on the outer limits of this bug. Unfortunately,
there was an unrelated libata bug which made it where 4 of my drives
were not recognized, and since the drive that has this general timeout
issue with linux is dedicated to an lvm I depend on those other drives
so I can mount the lvm so I can reproduce this bug.

What I do know:

Good: v2.6.25
Bad: pre v2.6.26-rc1 (9752082560b440e6a45624569d26802e20d1b8b4)

Please, How can I help further?
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
