Return-Path: <linux-kernel-owner+w=401wt.eu-S1765229AbYBMBHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765229AbYBMBHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYBMBHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:07:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59845
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbYBMBHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:07:31 -0500
Date: Tue, 12 Feb 2008 17:08:03 -0800 (PST)
Message-Id: <20080212.170803.205678080.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802130032190.14275@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
	<20080212.152652.217936905.davem@davemloft.net>
	<Pine.LNX.4.64.0802130032190.14275@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Wed, 13 Feb 2008 00:39:16 +0100 (CET)

> On the other hand, the H and S of CHS could be lowered and S increased,
> e.g. divide H by 2, divide S by 2, multiply S by 4. This gives a finer
> bytes/cylinder granularity.

That's really not an option when you only have 16-bits in the disk
label for some of these values, which is the case for Sun disk
labels and some others (f.e. BSD).

Jan, please get past this, it's a real issue and we therefore have to
skip the initial 1K or so in order to provide something even
approaching sane.

No modern filesystem should put it's superblock at position zero.

