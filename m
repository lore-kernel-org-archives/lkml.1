Return-Path: <linux-kernel-owner+w=401wt.eu-S933714AbZJMHdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbZJMHdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933696AbZJMHdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:33:14 -0400
Received: from relay.atmel.no ([80.232.32.139]:57460 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZJMHdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:33:14 -0400
Date: Tue, 13 Oct 2009 09:26:44 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the change
 to BUILD_BUG_ON
Message-ID: <20091013092644.72c78334@hskinnemoen-d830>
In-Reply-To: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> Commit 8c87df457cb5 fixed BUILD_BUG_ON with the result that some
> expressions (e.g. "not really constant" ones) result in a build failure.
> 
> Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.

This patch fixes the same issue:

http://lkml.org/lkml/2009/10/6/305

> -	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
> +	MAYBE_BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));

What's the difference between BUILD_BUG_ON() and MAYBE_BUILD_BUG_ON()?

Haavard
