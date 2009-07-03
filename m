Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZGCXRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZGCXRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 19:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZGCXRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 19:17:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42497 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZGCXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 19:17:23 -0400
Subject: Re: Memory leak in iwlwifi or false positive?
From: Catalin Marinas <catalin.marinas@arm.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246573533.17896.867.camel@rc-desk>
References: <1246570323.24044.16.camel@pc1117.cambridge.arm.com>
	 <1246573533.17896.867.camel@rc-desk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sat, 04 Jul 2009 00:17:22 +0100
Message-Id: <1246663042.14400.9.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2009 23:17:23.0331 (UTC) FILETIME=[6BC48530:01C9FC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reinette,

On Thu, 2009-07-02 at 15:25 -0700, reinette chatre wrote:
> On Thu, 2009-07-02 at 14:32 -0700, Catalin Marinas wrote:
> > pushed yet) it seems to no longer show so many random leaks. However, I
> > get a lot of leaks reported in the iwlwifi code, about 4800 and they do
> > not disappear from any subsequent memory scanning (as is usually the
> > case with false positives). There are a lot of kmalloc's of < 512 bytes
> > and /proc/slabinfo seems to be in line with this:
[...]
> Yes - this sounds about right. You tested with 5100 hardware which by
> default initializes 20 TX queues. For each of these queues it maintains
> a 256 buffer array of commands with 356 bytes used for each command.

With the latest kmemleak changes which I pushed to Linus they
disappeared. I missed the kmalloc_large in slub and probably some of the
root objects that keep references to others weren't scanned (maybe the
kzalloc call in wiphy_new was missed as it links to all the bulk of the
reported objects in the iwlwifi code).

Thanks.

-- 
Catalin

