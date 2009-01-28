Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbZA1SLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbZA1SLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZA1SLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:11:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbZA1SLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:11:04 -0500
Date: Wed, 28 Jan 2009 18:11:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ira Snyder <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: speed up request_firmware()
Message-ID: <20090128181117.35fb319b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090128180446.GB31107@ovro.caltech.edu>
References: <20090128180446.GB31107@ovro.caltech.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Without this patch, loading a 12MB firmware image (FPGA bitfiles) called
> vmalloc() approximately 3000 times. With the patch, vmalloc() is only
> called 13 times, however, some memory is wasted until firmware_release() is
> called. Usually, this happens very quickly, so it shouldn't be a problem.

Particularly on 32bit x86 vmalloc memory space is very precious so while
the current buffer size default may be too small doubling repeatedly is
not a good model IMHO.
