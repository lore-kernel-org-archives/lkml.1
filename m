Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZJ2OTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZJ2OTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZJ2OTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:19:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:34512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZJ2OTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:19:31 -0400
Message-ID: <4AE9A4BA.3020104@kernel.org>
Date: Thu, 29 Oct 2009 15:20:42 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rashmi Mohapatra <rashmilinux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Error in NCQ Command Handling in AHCI SATA
References: <8dd538850910290656q322b2c1aga1172c486361f7c4@mail.gmail.com>
In-Reply-To: <8dd538850910290656q322b2c1aga1172c486361f7c4@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, (cc list trimmed and linux-ide added)

DO NOT SPAM unrelated people.

Rashmi Mohapatra wrote:
> Please look at the log attached.
> Between line 1090 and 1210 something happens and the copy fails.
> If you look at Line No 1141 the log says,
> 
> qc_complete_multiple ap->qc_active=ffff qc_active=fbfe done_mask=401
> 
> Could it be possible that the software is issuing 32 commands MAX even
> if the Hardware supports less than that ?

Unlikely but then again you'll be the first to test an NCQ controller
with 16 command limit.

> Could it be a timeout issue for a block dma command ?
> 
> Why the scsi error handler code is called ?
> Can someone point me to the code flow which ends up calling the Error
> Handler ?

Commands were issued but the controller didn't report completion
before the timeout expired (30s), so the EH kicked in.  You have
multiple nobody cared warnings there.  Does specifying "irqpoll"
kernel parameter make any difference?

-- 
tejun
