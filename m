Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYATFnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYATFnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYATFna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:43:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYATFna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:43:30 -0500
Message-ID: <4792DE0C.9060906@zytor.com>
Date: Sat, 19 Jan 2008 21:37:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: disable_mtrr_trim only need for x86_64
References: <200801192045.17291.yinghai.lu@sun.com>
In-Reply-To: <200801192045.17291.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86: disable_mtrr_trim only need for x86_64
> 
> mtrr_trim_uncached_memory is only used in x86_64,
> 
> so disable_mtrr_trim is not needed for x86_32
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

That seems like a bug, and if so this patch goes the wrong direction. 
(If the 32-bit code has another solution for the same problem, they 
should be unified.)

The trimming of uncachable memory affects both 32- and 64-bit kernels; 
it's the same hardware, and even 32-bit kernels (with PAE) can access 
memory above 4 GB.

	-hpa
