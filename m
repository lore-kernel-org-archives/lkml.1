Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYFYWaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYFYWaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYFYWaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:30:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56643
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbYFYWaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:30:07 -0400
Date: Wed, 25 Jun 2008 15:30:07 -0700 (PDT)
Message-Id: <20080625.153007.207008169.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [3/10 PATCH] inline wake_up_bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <200806251617.40871.vda.linux@googlemail.com>
References: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
	<Pine.LNX.4.64.0806240156230.27784@engineering.redhat.com>
	<200806251617.40871.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 25 Jun 2008 16:17:40 +0200

> And you know what? This is likely not the end yet! It's possible
> spin_lock_irqXXX, __wake_up_common, waitqueue_active or bit_waitqueue
> are inlines - I didn't check.

The thing to do in these kinds of scenerios is to provide top-level
routes in kernel/sched.c where all the inlining occurs, rather
than doing it in header files and thus expanding this stuff in
multiple places.
