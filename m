Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZIQCSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZIQCSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZIQCSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:18:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51555 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZIQCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:18:38 -0400
Date: Wed, 16 Sep 2009 20:18:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Allen Kay <allen.m.kay@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [ACS v2 1/1] clean up base on Matt Wilcox feedback.
Message-ID: <20090917021841.GL29320@parisc-linux.org>
References: <1253153261-23398-1-git-send-email-allen.m.kay@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253153261-23398-1-git-send-email-allen.m.kay@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 07:07:41PM -0700, Allen Kay wrote:
> +/* Access Control Service */
> +#define  PCI_ACS_CAP		0x04	/* ACS Capability Register */
> +#define  PCI_ACS_CTRL		0x06	/* ACS Control Register */
> +#define  PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
> +#define  PCI_ACS_SV		0x01	/* Source Validation */
> +#define  PCI_ACS_TB		0x02	/* Translation Blocking */
> +#define  PCI_ACS_RR		0x04	/* P2P Request Redirect */
> +#define  PCI_ACS_CR		0x08	/* P2P Completion Redirect */
> +#define  PCI_ACS_UF		0x10	/* Upstream Forwarding */
> +#define  PCI_ACS_EC		0x20	/* P2P Egress Control */
> +#define  PCI_ACS_DT		0x40	/* Direct Translated P2P */

Oops, I wasn't clear.  The convention in this file is to use one space
after the #define for register names and two spaces for bits within
those registers.  Also, the bits generally go after the register to
which they apply.

So what I meant was more like this:

#define PCI_ACS_CAP		0x04	/* ACS Capability Register */
#define  PCI_ACS_SV		0x01	/* Source Validation */
#define  PCI_ACS_TB		0x02	/* Translation Blocking */
#define  PCI_ACS_RR		0x04	/* P2P Request Redirect */
...
#define PCI_ACS_CTRL		0x06	/* ACS Control Register */
#define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */

Since the bits are the same between CAP and CTRL, they don't need to
be repeated.

With this change,

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
