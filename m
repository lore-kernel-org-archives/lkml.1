Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYJWHQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYJWHQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYJWHPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:15:34 -0400
Received: from home.keithp.com ([63.227.221.253]:47712 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbYJWHPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:15:33 -0400
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches for 2.6.27-rc1)
Date: Thu, 23 Oct 2008 00:14:45 -0700
Message-Id: <1224746087-13991-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081022093615.GF12453@elte.hu>
References: <20081022093615.GF12453@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> okay. So ... mind sending your io_mapping patch as a generic facility? 
> It looks all good to me in its present form, except that it should live 
> in include/linux/io.h, not in the drivers/gpu/drm/i915/io_reserve.h file
> :-)

The first patch in this series (assuming I'm driving git-send-email
correctly) adds the io_mapping API. I ended up creating a new
linux/io_mapping.h file as the kernel init code uses io.h and got very angry
when I tried to include linux/highmem.h from that. I'm afraid I gave up at
that point and just moved the code to a new file. 

The second patch switches the drm/i915 driver to the new API. Performance
improvements on 64-bit kernels are impressive as we were using the slow path
before and now get to take advantage of 64-bit wonderfulness.
