Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXIYOw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXIYOw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXIYOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:52:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46082 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXIYOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:52:49 -0400
Date: Tue, 25 Sep 2007 16:52:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Subbaiah Venkata <kvsnaidu@sapnaidu.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/sort.c, 2.6.22 kernel
In-Reply-To: <000201c7da12$a1aec340$0a02a8c0@NetWin>
Message-ID: <Pine.LNX.4.64.0709251652050.945@fbirervta.pbzchgretzou.qr>
References: <000201c7da12$a1aec340$0a02a8c0@NetWin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8 2007 16:19, Subbaiah Venkata wrote:
>
>Hello, I fixed and tested a small bug in lib/sort.c file, heap sort
>function.
>
>The fix avoids unnecessary swap of contents when i is 0 (saves few
>loads and stores), which happens every time sort function is called.
>I felt the fix is worth bringing it to your attention given the
>importance and frequent use of the sort function.

Would you like to resubmit this? Please do ;)
(I am hinting at Documentation/SubmittingPatches too..)


>==================================================================
>diff --git a/lib/sort.c b/lib/sort.c
>index 9615678..6abbaf3 100644
>--- a/lib/sort.c
>+++ b/lib/sort.c
>@@ -67,7 +67,7 @@ void sort(void *base, size_t num, size_t size,
>        }
>
>        /* sort */
>-       for (i = n - size; i >= 0; i -= size) {
>+       for (i = n - size; i > 0; i -= size) {
>                swap(base, base + i, size);
>                for (r = 0; r * 2 + size < i; r = c) {
>                        c = r * 2 + size;
>
