Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbXEQA77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbXEQA77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbXEQA7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:59:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40529 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903AbXEQA7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:59:50 -0400
Date: Thu, 17 May 2007 09:59:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
Message-ID: <20070517005911.GB25935@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	garyhade@us.ibm.com
References: <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org> <464439C8.7090309@gmail.com> <20070512034928.GB29259@linux-sh.org> <20070516003002.GA18863@linux-sh.org> <464B3505.20004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517005016.GA25935@linux-sh.org> <464B3505.20004@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 06:44:53PM +0200, Tejun Heo wrote:
> +	/* FIXME: GoVault needs 2s but we can't afford that without
> +	 * parallel probing.  800ms is enough for iVDR disk
> +	 * HHD424020F7SV00.  Increase to 2secs when parallel probing
> +	 * is in place.
> +	 */
> +	ATA_TMOUT_FF_WAIT	= 4 * HZ / 5,
> +

Changing this to 4 * HZ / 4 gets rid of the occasional COMRESET failure.
So it would seem that 800ms is good enough for the common case, but it
seems to be cutting it pretty close..
