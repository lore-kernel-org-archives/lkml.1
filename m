Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYLEEWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYLEEWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYLEEWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:22:08 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4653 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYLEEWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:22:07 -0500
Subject: Re: [PATCH] Use vprintk rather that vsnprintf where possible
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
References: <1228423309.3255.109.camel@calx>
	 <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 20:21:45 -0800
Message-Id: <1228450905.13046.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 04:05 +0100, Kay Sievers wrote:
> If we convert to two printk calls for a single line, does that not
> possibly get mixed up with printks from other locations and lead to
> hardly readable log output?

Yes it does.

There are hundreds of possible interleaves in kernel
source today.  Adding a couple more isn't horrible.

The changes Matt proposes are good because they make the
kernel image smaller with a very minimal chance of
deciphering difficulty.

Someday there'll be a "multiline_printk_start/end"
mechanism that will avoid interleaving.

