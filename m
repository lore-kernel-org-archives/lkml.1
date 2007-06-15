Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbXFOSVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbXFOSVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXFOSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:21:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54082 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXFOSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:21:21 -0400
Message-ID: <4672D89D.7010801@zytor.com>
Date: Fri, 15 Jun 2007 11:21:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize is_power_of_2().
References: <1181926602.25193.5.camel@grianne>
In-Reply-To: <1181926602.25193.5.camel@grianne>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> From: Vegard Nossum <vegard@peltkore.net>
> Date: Fri, 15 Jun 2007 18:35:49 +0200
> Subject: [PATCH] Optimize is_power_of_2().
> 
> Rationale: Removes one conditional branch and reduces icache footprint.
> Proof: If n is false, the product of n and any value is false. If n is
> true, the truth of (n * x) is the truth of x.
> 

You realize that on a lot of platforms, multiplication is done by an
out-of-line subroutine, and that even on those that aren't, it's
generally a long-pipeline operation, right?

	-hpa
