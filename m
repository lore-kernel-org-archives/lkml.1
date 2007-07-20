Return-Path: <linux-kernel-owner+w=401wt.eu-S1764970AbXGTURs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764970AbXGTURs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbXGTURk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:17:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514AbXGTURj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:17:39 -0400
Date: Fri, 20 Jul 2007 13:17:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [IA64] Add mapping table between irq and vector
Message-Id: <20070720131728.a7335d92.akpm@linux-foundation.org>
In-Reply-To: <200707201959.l6KJxHAu019185@hera.kernel.org>
References: <200707201959.l6KJxHAu019185@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 19:59:17 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> +	BUG_ON(bind_irq_vector(irq, vector));

It's not good practice to do assert(expression-with-side-effects).  Because
if someone wants to create a build which has all the assertions disabled,
the resulting binary will not work.

In the present implementation our BUG_ON(expression) will evaluate
`expression' even if CONFIG_BUG=n.  But that's totally lame and we are just
leaving optimisation opportunities on the floor.

Our objective _should_ be to make BUG_ON(expr) generate no code at all if
CONFIG_BUG=n.

So please, prefer to do

	if (bind_irq_vector(irq, vector))
		BUG();

