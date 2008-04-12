Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYDLBDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYDLBDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 21:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbYDLBDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 21:03:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbYDLBDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 21:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=B2s/Ik2XY1+n0GF29DF0DnnlYtORA5COanEdhrzGNliFY9GkTRuHbhYka5uxcy9VIJ1HgcqPN8IQbbnEqK2XguLhPTh9r0dN6XjcK4bl4KVPNOzAoejFSeUSo6EOvPXMG+CuHBzq8YD3m5wrbAntOA+f8+PNsg97BWCT8sXirWs=
Date: Sat, 12 Apr 2008 04:59:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2: CONFIG_ATA_SFF: panic involving
	mount_block_root and down the road
Message-ID: <20080412005917.GA4742@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411234345.GA4742@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411234345.GA4742@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 03:43:45AM +0400, Alexey Dobriyan wrote:
> Pekka fixed SLUB for me, and now core2 box survives up and including to
> not finding / :
> 
> Setup is SATA disk with plain old partitions, nothing lvmancy:
> 
> 	/dev/sda2 on / type ext3 (rw,noatime)
> 
> CONFIG_ATA=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_AHCI=y
> CONFIG_ATA_PIIX=y
> CONFIG_PATA_JMICRON=y
> 
> sda1 is for swap.
> 
> 
> [    3.920000] NET: Registered protocol family 1
> [    3.920000] VFS: Cannot open root device "sda2" or unknown-block(0,0)

The winner is partly me, partly git-libata-all.

The latter introduced CONFIG_ATA_SFF option and put more or less every
SATA and PATA driver under it. The former honestly answered N to when
ATA_SFF popped up and failed to check existence of ATA_PIIX and
PATA_JMICRON in failing .config .

Now raise hands those who knew that your ATA controller is SFF
compliant.

