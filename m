Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYBRMbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYBRMbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYBRMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:30:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43549 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbYBRMax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:30:53 -0500
Date: Mon, 18 Feb 2008 05:30:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 4/5] signal(ia64): add a signal stack overflow check
Message-ID: <20080218123052.GG21012@parisc-linux.org>
References: <47B95D4F.8030003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B95D4F.8030003@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 06:26:23PM +0800, Shi Weihua wrote:
> +			if (!rbs_on_sig_stack(scr->pt.ar_bspstore))
> +				new_rbs = (current->sas_ss_sp +
> +					  sizeof(long) - 1) & ~(sizeof(long) - 1);

I know you're only moving this code, but how about fixing it to use
ALIGN at the same time?

+			if (!rbs_on_sig_stack(scr->pt.ar_bspstore))
+				new_rbs = ALIGN(current->sas_ss_sp,
+						sizeof(long));

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
