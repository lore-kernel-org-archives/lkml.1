Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYGDUnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYGDUnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYGDUnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:43:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33647
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYGDUna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:43:30 -0400
Date: Fri, 04 Jul 2008 13:43:29 -0700 (PDT)
Message-Id: <20080704.134329.209642254.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, dwmw2@infradead.org, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080704142753.27848ff8@lxorguk.ukuu.org.uk>
References: <1215178035.10393.763.camel@pmac.infradead.org>
	<486E2818.1060003@garzik.org>
	<20080704142753.27848ff8@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 4 Jul 2008 14:27:53 +0100

> There are good sound reasons for having a firmware tree, the fact tg3 is
> a bit of dinosaur in this area doesn't make it wrong.

And bnx2, and bnx2x, and e100's ucode (hope David caught that one!).

It isn't just tg3.

External firmware is by design an error prone system, even with
versioning.  But by being built and linked into the driver, it
is fool proof.

On a technical basis alone, we would never disconnect a crucial
component such as firmware, from the driver.  The only thing
charging these transoformations, from day one, is legal concerns.

I've been against request_firmware() from the beginning, because
they make life unnecessarily difficult, and it is error prone no
matter how well you design the validation step.
