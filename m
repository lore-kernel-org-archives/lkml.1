Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYATLZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYATLZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYATLZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:25:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57216 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYATLZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:25:26 -0500
Date: Sun, 20 Jan 2008 12:25:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/6] typesafe: kthread_create and kthread_run
In-Reply-To: <200801202048.34796.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0801201223590.14598@fbirervta.pbzchgretzou.qr>
References: <200801202046.14746.rusty@rustcorp.com.au>
 <200801202047.22943.rusty@rustcorp.com.au> <200801202048.34796.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 20 2008 20:48, Rusty Russell wrote:
>+ */
>+#define kthread_create(threadfn, data, namefmt...) ({		\
>+	int (*_threadfn)(typeof(data)) = (threadfn);		\
>+	__kthread_create((void *)_threadfn, (data), namefmt);	\
>+})

If you have namefmt... you need that varagrs cpp trick. IIRC:

	__kthread_create((void *)_threadfn, (data), namefmt, __VA_ARGS__);
