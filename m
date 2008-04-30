Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbYD3XiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbYD3XiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbYD3XiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:38:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57302 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755497AbYD3Xh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:37:59 -0400
Date: Thu, 1 May 2008 00:29:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] scsi: fix integer as NULL pointer warnings
Message-ID: <20080501002941.7e1e2f4a@core>
In-Reply-To: <1209593020.24729.112.camel@brick>
References: <1209593020.24729.112.camel@brick>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -				if (tw_dev->srb[request_id] != 0) {
> +				if (tw_dev->srb[request_id]) {

For pointers we should use == NULL or != NULL.

Removing the comparison removes the warning but it doesn't replace it
with any useful typechecking as can be doing with NULL set as (void *)0.

This is thus a backward step.

Alan
