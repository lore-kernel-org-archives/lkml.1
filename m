Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXGWWMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXGWWMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXGWWME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:12:04 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:21971 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXGWWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:12:01 -0400
X-IronPort-AV: i="4.16,572,1175486400"; 
   d="scan'208"; a="46301429:sNHT25029165"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Date: Mon, 23 Jul 2007 18:15:37 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707231419.13182.rgetz@blackfin.uclinux.org> <20070723131553.2943861f.akpm@linux-foundation.org>
In-Reply-To: <20070723131553.2943861f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231815.38124.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 23 Jul 2007 22:11:57.0948 (UTC) FILETIME=[7C5A5BC0:01C7CD76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23 Jul 2007 16:15, Andrew Morton pondered:
> This code would be
> simpler if it did not attempt to read more than one char at a time.  It
> will be plenty fast enough.

When systems have NMI kick off due to power failure, and you want to grab the 
log buffer to write it to flash before power really dies - every cycle 
counts.

A single function which does the copy as a loop (existing) is going to be much 
faster than the overhead of 1024 function calls to copy the last k.

> The magical interpretation of len isn't very nice. 

There are lots of places in the kernel which have magic in them :)

-Robin
