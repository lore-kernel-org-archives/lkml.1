Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYGJBoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYGJBoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGJBo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:44:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYGJBo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:44:26 -0400
Date: Wed, 9 Jul 2008 18:38:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 02/34] AMD IOMMU: add header file for driver data
 structures and defines
Message-Id: <20080709183823.52bbfd37.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-3-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:38 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> +/* helper macros */
> +#define LOW_U32(x) ((x) & ((1ULL << 32)-1))
> +#define HIGH_U32(x) (LOW_U32((x) >> 32))

Please avoid putting general-purpose helpers into private header files.

If we already have helper functions for this then use them.

If we don't have such helpers, let's write them, get them reviewed and put
them into kernel.h.

If we don't want these helpers in kernel.h then we don't want them in the
iommu driver either.

This cleanup work can be done separately from reviewing, testing amd
merging the IOMMU driver.
