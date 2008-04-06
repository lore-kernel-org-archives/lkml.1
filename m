Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYDFU5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYDFU5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYDFU5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:57:11 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:51479 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756375AbYDFU5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:57:06 -0400
Date: Sun, 6 Apr 2008 16:57:00 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel serial reduce trasmitting window & code style
 patch
Message-ID: <20080406165700.7802ef6f@siona.local>
In-Reply-To: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
References: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 10:39:06 +0200 (CEST)
Michael Trimarchi <trimarchimichael@yahoo.it> wrote:

> Reduce the trasmitting window size to avoid blocking of tasklet because 
> it must handle the receive phase too.
> 
> Signed-off-by: michael <trimarchi@gandalf.sssup.it>

Ok, the patch seems to make sense, but your description isn't very good...
  * What problem does this patch solve (I think I know it, but I don't
    want to guess.)
  * This patch doesn't really reduce any "TX window" since the window
    simply didn't exist before (or was infinitely long or whatever.) I
    think you should mention that this limitation is a new thing.
  * Why is 32 a good value?

Also, do we need to reschedule the tasklet if we terminate the loop
because of this limit? I think we can get away with not doing it since
the interrupt handler will be triggered as soon as we enable the TX
interrupt. But perhaps we should avoid enabling the interrupt and
schedule the tasklet since we _know_ there's a TX interrupt pending?

Haavard
