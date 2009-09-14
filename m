Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbZINWt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbZINWt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbZINWt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:49:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757402AbZINWtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:49:55 -0400
Date: Mon, 14 Sep 2009 15:49:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       jglisse@redhat.com
Subject: Re: [PATCH] drm/radeon/kms: R3XX/R4XX AGP asic use PCI GART not
 PCIE GART
Message-Id: <20090914154938.5d847481.akpm@linux-foundation.org>
In-Reply-To: <1252583229-13754-1-git-send-email-jglisse@redhat.com>
References: <1252583229-13754-1-git-send-email-jglisse@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 13:47:09 +0200
Jerome Glisse <jglisse@redhat.com> wrote:

> R3XX/R4XX AGP asic use the old PCI GART block, not the new PCIE GART.
> Make sure we pick the right GART when disabling AGP.
> 

This patch doesn't apply to 2.6.31.  It's not completely trivial to fix
either - these declarations

+ void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
+ int r100_pci_gart_enable(struct radeon_device *rdev);
+ void r100_pci_gart_disable(struct radeon_device *rdev);
+ int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);

would naturally lie in radeon_asic.h but we can't do that because some
stupidhead went and put this:

static struct radeon_asic r100_asic = {

into a .h file, making that header file unusable for the things which
header files are used for.


So please have another go.

If you believe that the the patch is suitable for backporting into 2.6.31.x
then please

- cc stable@kernel.org on the patch

- add a `Cc: <stable@kernel.org>' to the changelog

- ensure that the changelog text explains to the -stable maintainers why
  this patch should be backported.

Thanks.
