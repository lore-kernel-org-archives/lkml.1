Return-Path: <linux-kernel-owner+w=401wt.eu-S965753AbXC1UIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753AbXC1UIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXC1UIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:08:41 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60673 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965748AbXC1UIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:08:40 -0400
Date: Wed, 28 Mar 2007 21:08:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070328200829.GA12776@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070328000851.GA25551@srcf.ucam.org> <20070328105754.72b578bd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328105754.72b578bd@the-village.bc.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: HPA patches
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 10:57:54AM +0100, Alan Cox wrote:

> Ok thanks. This is interesting as the only thing new it is doing is
> asking for the HPA size. Does I think explain the problem however: Can
> you move the HPA setting call to after the mode has been set and see if
> that makes the problem vanish ?

Hm. I tried adding it in the eh code after ata_set_mode() in 
ata_eh_recover(), which alters the problem slightly - hpa_sectors is 
still 0, so the taskfile call is still failing, but now the system just 
stops at around the time that anything attempts to access sda with no 
errors other than

sd: 2:0:1:0: timing out command, waited 180s
sd: 2:0:1:0: SCSI error: return code = 0x00000028
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0

-- 
Matthew Garrett | mjg59@srcf.ucam.org
