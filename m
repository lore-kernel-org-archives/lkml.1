Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXKFKSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXKFKSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXKFKSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:18:45 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:23116 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXKFKSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=khcpyWikPhloRMWoSYAy0Vh3l1vY1FEIXuCETnD2Sj2iY0srz0sYhz0ZcFDbtcQQ1wLwUJgex0Qt0T7C7G7GP7VVHiZwIFRwTkl9/XYSym8NczfmB87U6IcpCFJdGDj398B9dRRvdI1/rmDJg4Ebo5Bc7yZT1TQwxoq4Xd4OhUw=
Message-ID: <47303F77.9080502@gmail.com>
Date: Tue, 06 Nov 2007 19:18:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: albertl@mail.com, albertcc@tw.ibm.com, Daniel Drake <dsd@gentoo.org>,
       Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org>	<20071101141501.3746cec2@the-village.bc.nu>	<4729F1BB.20306@gentoo.org>	<4729F8F1.4040103@gmail.com>	<472B946F.4030004@gentoo.org>	<472BCC18.7070503@gmail.com>	<472CD3F3.7050701@gentoo.org>	<472D0D4A.70404@gmail.com>	<472D445B.1080005@tw.ibm.com>	<20071104234205.7627d007@the-village.bc.nu>	<472E5E5C.8040308@gmail.com> <20071105130330.06a22f7a@the-village.bc.nu>
In-Reply-To: <20071105130330.06a22f7a@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 05 Nov 2007 09:05:48 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Alan Cox wrote:
>>>> Maybe we could set a limit here. If the ATAPI device keeps DRQ=1 and
>>>> exceeds the limit, we consider it as HSM violation and have EH handle it.
>>> On a DMA transfer its basically out of our control (and a PIO drain will
>>> lock some controllers solid until power cycle),
>> Do such controllers lock up on PIO draining after PIO transfers too?
>> Can you tell which are those controllers?
> 
> Promise PDC202xx will lock on a PIO drain of a DMA transfer or (if you
> reset it before you drain) on a PIO drain of a PIO transfer.

Just to make sure I'm not misunderstanding it.  So, PDC202xx will lock
up if you transfer allocation size, reset and then try to drain, but
it's okay to keep draining as part of continued PIO transfer, right?

-- 
tejun
