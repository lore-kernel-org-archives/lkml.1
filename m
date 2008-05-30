Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYE3ETx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYE3ETx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbYE3ETk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:19:40 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:17710 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbYE3ETj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ssu54htZmWyc12KXsQa/MVV/5Unc6LJtFWakGP5Ap4cr3FLAMu2wBD8AqYtIylnXUqqTrDFrT5lfMRxexBgoDqeJHx6oayJcO8ecAf6niCmhW+hRpq8cPF8a2XNkuspBk+lwh9tM2y/BTvJtiDwaM09Ik/iWkFSDHnmTRux2JRE=
Message-ID: <483F804F.1@gmail.com>
Date: Fri, 30 May 2008 13:19:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
CC: Peer Chen <pchen@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804221444.55483.volker.armin.hemmann@tu-clausthal.de> <480DF1F5.3060208@gmail.com> <200805291654.03617.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200805291654.03617.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hemmann, Volker Armin wrote:
> -AHCI+nomsi: boots fine. Works fine. But: I still can not enable ncq
> -AHCI+msi: the usual. No harddisks found, waiting for the timeouts, then 
> kernel panic because of missing root.
> 
> -NON-RAID/IDE+msi: works fine. No delays. No NCQ (not surprising since mobos 
> handbook says that AHCI mode is required).
> -NON-RAID/IDE+nomsi: see above.

So, sans NCQ, the only remaining issue is MSI, right?  Peer Chen, please
lemme know which controllers are affected by this MSI problem and where
the problem lies.

> but:
> [14315325.624510] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
> 0xf impl SATA mode
> [14315325.624559] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
> 
> shouldn't controller and harddisks support turning on NCQ? The handbooks says 
> that NCQ is supported in AHCI mode and the harddisks doesn't seem to be 
> blacklisted.

The controller is not reporting NCQ capability in its cap register
(flags: line contains ncq if the controller is), so NCQ is not enabled.

Thanks.

-- 
tejun
