Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZDTLGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZDTLGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZDTLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:06:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58914 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZDTLGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:06:39 -0400
Date: Mon, 20 Apr 2009 05:06:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] pci, msi: Remove unused/obsolete macros and definitions
Message-ID: <20090420110637.GR1926@parisc-linux.org>
References: <49EBD5EC.4040905@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EBD5EC.4040905@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 10:54:52AM +0900, Hidetoshi Seto wrote:
>  - Remove unused msi/msix_enable/disable macros.
>    User should use msi/msix_set_enable() functions instead.

I don't think they were ever intended for drivers; I think they were
supposed to be helper macros for msi.c.  Regardless, deleting them is
the right thing to do.

>  - Remove unused msix_mask/unmask/pending macros.
>    These macros are useless because they are not based on any of
>    the PCI Local Bus Specifications properly.
>    It seems that they were written based on a draft of PCI spec,
>    and that the draft was the MSI-X ECN that underwent membership
>    review in September 2002.
>    (* In the draft, the size of a entry in MSI-X table was 64bit,
>       containing 32bit message data and DWORD aligned lower address
>       plus a pending bit and a mask bit.(30+1+1bit)  The higher
>       address was placed in MSI-X capability structure and shared
>       by all entries.)

I think you're right.  Unfortunately, the old MSI-X ECN was actually
incorporated into a version of the PCI 3.0 spec -- I have a document
here named pci3.0-081202.pdf which has exactly the layout you describe.
So it probably gained wider currency than it should have.

>  - Remove PCI_MSIX_FLAGS_BITMASK.
>    This definition also come from the draft ECN.

Yep.

> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
