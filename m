Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbXH3Pbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbXH3Pbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbXH3Pbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:31:39 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2637 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757621AbXH3Pbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:31:38 -0400
Date: Thu, 30 Aug 2007 17:32:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i2c transfers during interrupt context
Message-ID: <20070830173232.270c6f70@hyperion.delvare>
In-Reply-To: <38b2ab8a0708300655n7ae6a445y84150ab1bdcdf2d4@mail.gmail.com>
References: <38b2ab8a0708300311x5479effn5999ba118221a47f@mail.gmail.com>
	<38b2ab8a0708300655n7ae6a445y84150ab1bdcdf2d4@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bonjour Francis ;)

On Thu, 30 Aug 2007 15:55:49 +0200, Francis Moreau wrote:
> I have a very simple question about i2c transfers.
> 
> I'm wondering if I'm allowed to initiate some very short i2c transfers
> in an interrupt handler.

Non. Tu n'as pas le droit de dormir dans un gestionnaire
d'interruption, et la majorité des pilotes I2C dorment pendant les
transferts.

Si tu as besoin de faire ce genre de chose il faut typiquement passer
par une workqueue.

-- 
Jean Delvare
