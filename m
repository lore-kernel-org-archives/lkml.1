Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYLJRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYLJRIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYLJRII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:08:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47272 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYLJRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:08:07 -0500
To: Hannes Eder <hannes@hanneseder.net>
Cc: Karsten Keil <kkeil@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] mISDN: fix sparse warnings
From: Andi Kleen <andi@firstfloor.org>
References: <493feac3.25e2660a.2824.6cb2@mx.google.com>
Date: Wed, 10 Dec 2008 18:08:24 +0100
In-Reply-To: <493feac3.25e2660a.2824.6cb2@mx.google.com> (Hannes Eder's message of "Wed, 10 Dec 2008 16:43:30 +0100")
Message-ID: <87hc5cc60n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder <hannes@hanneseder.net> writes:
> @@ -918,7 +919,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
>  	/* Disable sync of all cards */
>  	list_for_each_entry_safe(hc, next, &HFClist, list) {
>  		if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
> -			plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
> +			plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);

It would be probably better to declare plx_membase __iomem too instead
of so much casting.

-Andi

-- 
ak@linux.intel.com
