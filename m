Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYBEMry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYBEMry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBEMrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:47:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYBEMrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:47:46 -0500
Date: Tue, 5 Feb 2008 13:47:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PULL] virtio updates
Message-ID: <20080205124728.GA18701@elte.hu>
References: <200802050008.13834.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802050008.13834.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Rusty Russell (16):
>       virtio: balloon driver

this change breaks the x86 build, as 'make randconfig' testing found it 
after 2 iterations:

  drivers/virtio/virtio_balloon.c: In function 'fill_balloon':
  drivers/virtio/virtio_balloon.c:98: error: implicit declaration of function 'msleep'

the patch below fixes it.

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/virtio/virtio_balloon.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/virtio/virtio_balloon.c
===================================================================
--- linux.orig/drivers/virtio/virtio_balloon.c
+++ linux/drivers/virtio/virtio_balloon.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 struct virtio_balloon
 {
