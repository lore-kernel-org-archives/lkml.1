Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYFEEy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYFEEy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 00:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYFEEyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 00:54:46 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:16418 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYFEEyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 00:54:45 -0400
X-IronPort-AV: E=Sophos;i="4.27,592,1204531200"; 
   d="scan'208";a="76137666"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Brice Goglin <brice@myri.com>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "venkatesh.pallipadi\@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: howto use ioremap_wc?
References: <4841143E.5080003@myri.com>
	<20080531185424.1cd18220@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Jun 2008 21:53:54 -0700
In-Reply-To: <20080531185424.1cd18220@infradead.org> (Arjan van de Ven's
	message of "Sat, 31 May 2008 18:54:24 -0700")
Message-ID: <adad4mw1nz1.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Jun 2008 04:53:55.0223 (UTC) FILETIME=[28513A70:01C8C6C8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This thread reminds me of another question about interfaces for using
PAT.  Are there any plans for making pgprot_writecombine() a generic
interface that portable drivers can use to map PCI memory into userspace
with WC turned on?  (Falling back to uncached when WC is not available
for whatever reason is fine for the case I have in mind)

Maybe it's better to ask at a higher level: what's the right thing for a
driver to do in an mmap method when it wants to expose PCI memory to
userspace with WC turned on if possible?  I see that the PCI sysfs code
on x86 does it using non-exported (hence not available to a driver
buildable as a module) interfaces.

Thanks,
  Roland
