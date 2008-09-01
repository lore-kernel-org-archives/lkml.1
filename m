Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbYIAWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbYIAWc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYIAWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:32:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45375 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYIAWcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:32:19 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Misc fixes for 2.6.27
From: Andi Kleen <andi@firstfloor.org>
References: <1220300084.2982.139.camel@pmac.infradead.org>
Date: Tue, 02 Sep 2008 00:32:16 +0200
In-Reply-To: <1220300084.2982.139.camel@pmac.infradead.org> (David Woodhouse's message of "Mon, 01 Sep 2008 21:14:44 +0100")
Message-ID: <87wshvwl8v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:
> +
> +static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
> +	{	/* Some DG33BU BIOS revisions advertised non-existent VT-d */

Are you sure it's non existent? A G33 chipset should have it in
hardware I thought.

I'm not sure this is really the right way to handle this anyways.
If there's ever a working BIOS it will be blacklisted too. And
normally BIOS bugs don't come in one board alone, but in a range
of them and then adding more and more identifiers is quite painful.

Better would be to add some generic sanity checks that catches
the issues these BIOS revisions are having.

> +		.callback = blacklist_iommu,
> +		.ident = "Intel DG33BU",
> +		{	DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
> +			DMI_MATCH(DMI_BOARD_NAME, "DG33BU"),
> +		}
> +	},

-Andi

-- 
ak@linux.intel.com
