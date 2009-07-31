Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZGaM4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZGaM4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZGaM4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:56:38 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59684 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbZGaM4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:56:38 -0400
Subject: Re: kmemleak report from network usage
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux.nics@intel.com
In-Reply-To: <c4e36d110907310521v1234e8fdg99a101a4057dc51e@mail.gmail.com>
References: <c4e36d110907310521v1234e8fdg99a101a4057dc51e@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 31 Jul 2009 13:56:32 +0100
Message-Id: <1249044992.29967.17.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2009 12:56:33.0689 (UTC) FILETIME=[54D13890:01CA11DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zdenek,

On Fri, 2009-07-31 at 14:21 +0200, Zdenek Kabelac wrote:
> Recently I'm running kernel with kmemleak.

Which kernel version?

> Here are some frequently repeating messages:
> 
> Are they false positives or some real leaks?

Could be either (but it depends on the kernel version as well since
there were some kmemleak fixes during the -rc stages).

Can you merge the "kmemleak-fixes" branch from
git://linux-arm.org/linux-2.6.git (or just pick
http://www.linux-arm.org/git?p=linux-2.6.git;a=commitdiff;h=4d2b5efa46639b704fd5db1ccd3bdf51cadda50e which ensures that all thread stacks are scanned)?

Are the same leaks still reported reported after a few
"echo scan > /sys/kernel/debug/kmemleak"? If not, they are just
transient leaks, happening especially on SMP systems. If they are still
present, could you please also post the relevant .config entries?

Thanks.

-- 
Catalin

