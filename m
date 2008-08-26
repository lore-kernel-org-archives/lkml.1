Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYHZVsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYHZVsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHZVr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:47:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40655 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750990AbYHZVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:47:58 -0400
Date: Tue, 26 Aug 2008 22:08:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@us.ibm.com, dvelarde@us.ibm.com,
       serue@us.ibm.com, safford@us.ibm.com
Subject: Re: [PATCH][resubmit] TPM: update char dev BKL pushdown
Message-ID: <20080826220823.509571fd@lxorguk.ukuu.org.uk>
In-Reply-To: <1219784185.4768.6.camel@blackbox>
References: <1219784185.4768.6.camel@blackbox>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	atomic_set(&chip->is_open, 1);
> +	get_device(chip->dev); /* protect from chip disappearing */

Why not just use test_and_set_bit() ? You seem to be abusing atomic_t to
achieve this.
