Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYIQTVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYIQTVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYIQTUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:20:54 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37911 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbYIQTUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:20:53 -0400
Date: Thu, 18 Sep 2008 04:20:18 +0900
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
	<1221670377-19295-4-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080918041104K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 18:52:37 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> The IO/TLB flushing on every unmaping operation is the most expensive
> part there and not strictly necessary. It is sufficient to do the flush
> before any entries are reused. This is patch implements lazy IO/TLB
> flushing which does exactly this.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  Documentation/kernel-parameters.txt |    5 +++++
>  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
>  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
>  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
>  4 files changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c2e00ee..5f0aefe 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  			isolate - enable device isolation (each device, as far
>  			          as possible, will get its own protection
>  			          domain)
> +			unmap_flush - enable flushing of IO/TLB entries when
> +			              they are unmapped. Otherwise they are
> +				      flushed before they will be reused, which
> +				      is a lot of faster
> +

Would it be nice to have consistency of IOMMU parameters?

VT-d also has the kernel-boot option for this lazy flushing trick
though VT-d 'strict' option is more vague than 'unmap_flush'

It would be also nice to have consistency of IOMMU behavior.

VT-d enables the lazy flushing trick by default and has the boot
option to disable it.
