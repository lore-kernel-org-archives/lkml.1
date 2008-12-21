Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYLUOoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYLUOoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYLUOon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:44:43 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49716 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYLUOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JOuOhFwNXmFH/vXxIEcfPOTEotfsgNoq0IROxpvyjWyrDZWr0mQZdNOpC2bmR5mRdD
         tP4ZA/HWI7nMko4fOMOHEit0nBwum4snL364mO/9IdJQ9AgjJvYavfFsPs/rtyRFE6TH
         GyBCcNpNIiqWHU269dkSd1d5d+J0B9zgSOy7A=
Message-ID: <19f34abd0812210644j6f11717bi84238d172feed8b6@mail.gmail.com>
Date: Sun, 21 Dec 2008 15:44:40 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] netlink: fix (theoretical) overrun in message iteration
Cc: "Thomas Graf" <tgraf@suug.ch>, "Eugene Teo" <eugeneteo@kernel.sg>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081221134218.GA7959@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081221134218.GA7959@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 2:42 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From bb805d89e84ddb11c9bb58afcfd9a6b37bbe5a9b Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 21 Dec 2008 14:20:49 +0100
> Subject: [PATCH] netlink: fix (theoretical) overrun in message iteration
>
> See commit 1045b03e07d85f3545118510a587035536030c1c for a detailed
> explanation of why this patch is necessary.
>
> In short, nlmsg_next() can make "remaining" go negative, and the
> remaining >= sizeof(...) comparison will promote "remaining" to an
> unsigned type, which means that the expression will evaluate to
> true for negative numbers, even though it was not intended.
>
> I put "theoretical" in the title because I have no evidence that
> this can actually happen, but I suspect that a crafted netlink
> packet can trigger some badness.

nlmsg


-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
