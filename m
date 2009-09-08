Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZIHSGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZIHSGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZIHSGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:06:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZIHSGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:06:36 -0400
Date: Tue, 8 Sep 2009 15:06:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?UTF-8?B?THVrw6HFoQ==?= Karas <lukas.karas@centrum.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix saa7134-input.c for IR controller over i2c
Message-ID: <20090908150613.49bc72eb@caramujo.chehab.org>
In-Reply-To: <200909081148.23791.lukas.karas@centrum.cz>
References: <200909081148.23791.lukas.karas@centrum.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 8 Sep 2009 11:48:23 +0200
Lukáš Karas <lukas.karas@centrum.cz> escreveu:

> Hi All, 
> I have DVB card with IR controller connected over i2c bus (this card is 
> supported by module saa7134). This IR controller work mostly fine, bud when I 
> execute 
> rmmod ir-kbd-i2c and modprobe ir-kbd-i2c again, IR controller stops working.
> I found problem in aa7134-input.c, metod saa7134_probe_i2c_ir. 

>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
>  	memset(&info, 0, sizeof(struct i2c_board_info));
> -	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
> +	init_data = kzalloc(sizeof(struct IR_i2c_init_data), GFP_KERNEL);

you need to free it at the proper places. Anyway, we have already a fix for it at:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=3a7ec2c0d6fdda454d5588c03208ddfcbe16ac18

(I'll probably rework on it a little bit to remove the memset's and to fix a typo)



Cheers,
Mauro
