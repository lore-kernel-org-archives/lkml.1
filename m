Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbXBOXdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbXBOXdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXBOXdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:33:07 -0500
Received: from ns.suse.de ([195.135.220.2]:49574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXBOXdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:33:06 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Walrond <andrew@walrond.org>
Date: Fri, 16 Feb 2007 10:32:19 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17876.60803.90156.440903@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Modular kernel (2.6.20) and software raid auto detection
In-Reply-To: message from Andrew Walrond on Thursday February 15
References: <200702151920.00028.andrew@walrond.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday February 15, andrew@walrond.org wrote:
> 
> With my ide driver and the md stuff all built into the kernel, my software 
> raid drives and associated /dev/md? devices are detected and created by the 
> kernel.

Yep.

> 
> With the md stuff built in but the ide driver modular and loaded later by 
> udev, the drives are not detected.

No, they aren't.

> 
> So, I guessed that perhaps if I made the md stuff modular aswell and load it 
> _after_ loading the ide driver, this might kickstart the auto-detect stuff. 
> But it didn't :(

No, it wouldn't.

> 
> Is there a way to make auto-detection work without having the ide driver built 
> in?

Don't use in-kernel auto-detection.  Use mdadm to do the
auto-detection for you.

  mdadm --assemble --scan --homehost='<system>' --auto-update-homehost

might work providing your hostname has been set by the time it runs.

NeilBrown
