Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYA1NIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYA1NIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYA1NIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:08:41 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52700 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYA1NIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:08:39 -0500
Message-Id: <01c801c861ae$c2349990$41a8400a@bsd.tnes.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "David Chinner" <dgc@sgi.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
       <linux-ext4@vger.kernel.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080126053526.GN155407@sgi.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Mon, 28 Jan 2008 22:07:38 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your comments.

> That's inherently unsafe - you can have multiple unfreezes
> running in parallel which seriously screws with the bdev semaphore
> count that is used to lock the device due to doing multiple up()s
> for every down.
> 
> Your timeout thingy guarantee that at some point you will get
> multiple up()s occuring due to the timer firing racing with
> a thaw ioctl. 
> 
> If this interface is to be more widely exported, then it needs
> a complete revamp of the bdev is locked while it is frozen so
> that there is no chance of a double up() ever occuring on the
> bd_mount_sem due to racing thaws.....

My patch has the race condition as you said.
I will fix it.

Cheers, Takashi 

