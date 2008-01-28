Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYA1LlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYA1LlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYA1LlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:41:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33047 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYA1LlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:41:04 -0500
To: hugh@veritas.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0801280534370.15609@sister.site> (message from
	Hugh Dickins on Mon, 28 Jan 2008 06:09:26 +0000 (GMT))
Subject: Re: [patch 24/26] mount options: fix tmpfs
References: <20080124193341.166753833@szeredi.hu> <20080124193454.408283578@szeredi.hu> <Pine.LNX.4.64.0801280534370.15609@sister.site>
Message-Id: <E1JJSMA-00009M-4h@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Jan 2008 12:40:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Thanks Miklos, that's a welcome enhancement, nicely done.  I've only
> noticed one thing wrong (MPOL_PREFERRED shown as "default"); but thought
> shmem_config didn't add much value - I'd rather avoid those syntactic
> changes to unchanged code; and several tmpfs defaults being relative
> (e.g. to totalram_pages, or to mounter's fsuid), I ended up preferring
> to do real tests in shmem_show_options.

I completely agree, this is much better than my version.

> Thus, for example, if memory is hotplugged in or out later, what started
> out as an unspecified size option will then get shown as explicit size.
> (I did think for a while that I wanted to show explicit size in all
> cases; but it looked pretty silly on udev.)  I think that's the correct
> behaviour, that otherwise would be misleading; but I may be looking at
> this the wrong way round, what's your view?

I agree, this is the correct way.

I'll add functions for calculating the default max values, so the
calculations won't accidentally become different for the
initialization and the option showing.

> If you agree with the version below, please take it into your collection
> and insert your Signed-off-by.  I should admit, I've not yet tested how
> the NUMA policies look: you'll hear from me again tomorrow morning if
> those turn out to wrong.

OK, I'll send this to Andrew.  Maybe I'll wait until tomorrow to hear
if it's working on NUMA.

Thanks,
Miklos
