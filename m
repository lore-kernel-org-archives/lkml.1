Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYIALUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYIALUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYIALUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:20:38 -0400
Received: from smtp.nokia.com ([192.100.122.233]:36408 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYIALUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:20:37 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220262187.2982.58.camel@pmac.infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 01 Sep 2008 14:16:50 +0300
Message-Id: <1220267810.4036.24.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Sep 2008 11:20:15.0154 (UTC) FILETIME=[B4FC0120:01C90C24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 10:43 +0100, David Woodhouse wrote:
> > UBIFS stores 16-bit UUID in the superblock, and it is a good
> > idea to return part of it in 'f_fsid' filed of kstatfs structure.
> 
> I think you mean a 16-byte UUID, not 16-bit?

Oh, right.

> 
> > +	memcpy(&buf->f_fsid, c->uuid, sizeof(__kernel_fsid_t));
> 
> For btrfs I xor the first 64 bits with the second 64 bits, and put
> _that_ into f_fsid. You're just putting the first 64 bits in and
> ignoring the second 64 bits. Neither is really _better_ than the other;
> you just alter the circumstances in which you get collisions. But I
> suppose we might as well be consistent about how we do it?

Well, xor-ing should not make the random UUID more random, but for
consistency purposes sure, I may use xor as well.

> Alternatively, there's space in the struct statfs to export a couple
> more uint32_ts, and thus the _whole_ of the uuid. Perhaps we should do
> that?

You mean f_spare? I do not think any application would use it so I doubt
it is good idea to use it.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

