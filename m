Return-Path: <linux-kernel-owner+w=401wt.eu-S1030556AbXAYUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030556AbXAYUey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 15:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030557AbXAYUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 15:34:54 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:35667 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030556AbXAYUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 15:34:54 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=hBfCjsD3lq7KWChK3XKsWDbZPmu5/pbfGrJmUsiHrkIkATlxzR5aEmSdC/OwbiylRm/9wkoszEGEpP1TwtbEOjLs+XLkdsMoNJ54NOZPtA/tlb1Mk+HbBx4UbNGS+Fbl;
X-IronPort-AV: i="4.13,239,1167631200"; 
   d="scan'208"; a="169323891:sNHT18069471"
Date: Thu, 25 Jan 2007 14:34:56 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, matthew.e.tolentino@intel.com,
       anil.s.keshavamurthy@intel.com
Subject: Re: [PATCH] Fix race in efi variable delete code.
Message-ID: <20070125203456.GB16521@lists.us.dell.com>
References: <20070122152209.29717.52473.sendpatchset@prarit.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122152209.29717.52473.sendpatchset@prarit.boston.redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 10:22:09AM -0500, Prarit Bhargava wrote:
> Fix race when deleting an EFI variable and issuing another EFI command on the
> same variable.  The removal of the variable from the efivars_list should be
> done in efivar_delete and not delayed until the kprobes release.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

But then we'll leave it dangling on the list at module unload time.
Let me rework this and send you something to try.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
