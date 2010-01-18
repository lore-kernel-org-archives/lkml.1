Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876Ab0ARSXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0ARSXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847Ab0ARSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:23:40 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40385 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0ARSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=RpRscxl590cA9NxvXWmvd4A66hm8+jnJDTlmANOwHcyV7qUM/j/qIuVcIx8DRzKx3A
         BnTFcOsiJQvq/LTRCEzubWDzSzFzBEdIiBscYqmKspcRcwkesUbRHyLe3HsNDNz2/XDs
         0A/LgXrmMjTEuMxvpY80JDsAZLN+nIwb8O1hw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 07/64] pata_atiixp: enable parallel scan
Date: Mon, 18 Jan 2010 19:18:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171447.14623.47438.sendpatchset@localhost> <20100118175256.32096b44@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118175256.32096b44@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <201001181918.49304.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010 06:52:56 pm Alan Cox wrote:
> >  	const struct ata_port_info *ppi[] = { &info, &info };
> > +	struct ata_host *host;
> > +	int rc;
> >  
> > -	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
> > +	/* enable device and prepare host */
> > +	rc = pcim_enable_device(pdev);
> > +	if (rc)
> > +		return rc;
> > +
> > +	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
> > +	if (rc)
> > +		return rc;
> > +
> > +	host->flags |= ATA_HOST_PARALLEL_SCAN;
> > +
> > +	pci_set_master(pdev);
> > +
> > +	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &atiixp_sht);
> >  }
> 
> Adding a small essay to each host that activates parallel scan doesn't
> make sense. This should be a helper (ignore that if you make it a helper
> later in the patch set...)

Patch adding such helper would be probably a nice incremental improvement,
though 'a small essay' works just fine for the current needs as parallel
scanning functionality is added only to pata_atiixp and pata_efar hosts..

--
Bartlomiej Zolnierkiewicz
