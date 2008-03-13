Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYCMXHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYCMXHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYCMXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:06:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYCMXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:06:52 -0400
Date: Thu, 13 Mar 2008 16:06:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
Subject: Re: [patch 2.6.25-rc5 2/2] gpiochip_reserve()
Message-Id: <20080313160606.219166f5.akpm@linux-foundation.org>
In-Reply-To: <200803131552.22122.david-b@pacbell.net>
References: <200803131552.22122.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 14:52:21 -0800
David Brownell <david-b@pacbell.net> wrote:

> +int __init __must_check gpiochip_reserve(int start, int ngpio)

I applaud the addition of __msut_check to a newly-added function of this
kind, but we usually only add the tag to the declaration, not to the
definition as well.

Not a lot of thought went into this, but we might as well be consistent.

--- a/drivers/gpio/gpiolib.c~gpiochip_reserve-fix
+++ a/drivers/gpio/gpiolib.c
@@ -121,7 +121,7 @@ static int gpiochip_find_base(int ngpio)
  * to mark a range of gpios as unavailable for dynamic gpio number allocation,
  * for example because its driver support is not yet loaded.
  */
-int __init __must_check gpiochip_reserve(int start, int ngpio)
+int __init gpiochip_reserve(int start, int ngpio)
 {
 	int ret = 0;
 	unsigned long flags;


