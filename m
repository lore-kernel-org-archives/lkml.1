Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZHQXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZHQXWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758285AbZHQXWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:22:44 -0400
Received: from solitude.tty.gr ([95.154.208.37]:52207 "EHLO mx.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHQXWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:22:44 -0400
Message-ID: <4A89E63E.407@debian.org>
Date: Tue, 18 Aug 2009 02:22:38 +0300
From: Faidon Liambotis <paravoid@debian.org>
Organization: Debian
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       iommu@lists.linux-foundation.org,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [regression, bisected] fails to boot on Dell Optiplex 760 with
 VT-d enabled
References: <4A89CB52.4030008@debian.org> <20090817231156.GJ24885@sequoia.sous-sol.org>
In-Reply-To: <20090817231156.GJ24885@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> AFAIK, this platform is broken when VT-d is enabled.
> Can you add this patch to a broken kernel and retest?
> Please boot with 'debug' on the kernel command line.
Thanks but David was faster, we've already established that

http://git.infradead.org/iommu-2.6.git/commit/0815565a

which is, as far as I can understand, very similar to your patch, indeed
fixes the issue.

> +	if (ver == (u32)-1 || iommu->cap == (u64)-1 || iommu->ecap == (u64)-1) {
As an observation, David's patch is checking if *both* iommu->cap and
iommu->ecap are -1, while yours checks for either. You're also checking
for ver. Obviously, I have no idea which of the two is more correct.

Thanks,
Faidon
