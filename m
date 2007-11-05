Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbXKEAGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbXKEAGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXKEAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:05:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:4322 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKEAF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YVdYJnhpPyX9xVPexIaMiBVYA9zsgKv7c9/BzA2tJ1AyhRKsiUMJjgqrHjxGfYq1VvrNrGBEXL21Y3BDxuEYXtQvEwQuLa9ejgihJKkPQCPjAESLOp8Sg0r/AWSyJEoJXKfcK0CCO260dcdyWveCqdGx2v/JrzE65MzkLBCocEA=
Message-ID: <472E5E5C.8040308@gmail.com>
Date: Mon, 05 Nov 2007 09:05:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: albertl@mail.com, albertcc@tw.ibm.com, Daniel Drake <dsd@gentoo.org>,
       Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org>	<20071101141501.3746cec2@the-village.bc.nu>	<4729F1BB.20306@gentoo.org>	<4729F8F1.4040103@gmail.com>	<472B946F.4030004@gentoo.org>	<472BCC18.7070503@gmail.com>	<472CD3F3.7050701@gentoo.org>	<472D0D4A.70404@gmail.com>	<472D445B.1080005@tw.ibm.com> <20071104234205.7627d007@the-village.bc.nu>
In-Reply-To: <20071104234205.7627d007@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Maybe we could set a limit here. If the ATAPI device keeps DRQ=1 and
>> exceeds the limit, we consider it as HSM violation and have EH handle it.
> 
> On a DMA transfer its basically out of our control (and a PIO drain will
> lock some controllers solid until power cycle),

Do such controllers lock up on PIO draining after PIO transfers too?
Can you tell which are those controllers?

> but on PIO we know we
> never set a chunk size over 64K, so if we exceed 64K its time to apply a
> larger hammer

Draining is related to the amount of data the drive responds not to the
chunk size.  I agree 64k should be enough for most cases but I think
there can be corner cases where this doesn't hold.

Thanks.

-- 
tejun
