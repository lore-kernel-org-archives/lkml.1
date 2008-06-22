Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYFVBNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYFVBNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 21:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYFVBNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 21:13:07 -0400
Received: from userg500.nifty.com ([202.248.238.80]:50557 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYFVBNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 21:13:05 -0400
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=DJmn0VWrw8GZsh8dG84p8Vjv67uiWL0J2ec4iEBA19GXK4bUfpXwEh+HfgvqqKStM
	weEFCztyDDxCgulSk+sKA==
X-Nifty-SrcIP: [220.145.30.34]
Date: Sun, 22 Jun 2008 10:07:51 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080622100751.dd019b01.komurojun-mbn@nifty.com>
In-Reply-To: <4855D8E2.10409@gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
	<48537149.4040102@garzik.org>
	<20080614213612.96873c25.komurojun-mbn@nifty.com>
	<4855D8E2.10409@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Strangely, after removing the spin_lock_irqsave
and spin_unlock_irqrestore from the ata_eh_reset,
the pata_pcmcia works properly.

It seedms link->ap->lock is not intialized
by spin_lock_init().

-     spin_lock_irqsave(link->ap->lock, flags);
      link->eh_info.serror = 0;
-     spin_unlock_irqrestore(link->ap->lock, flags);
 


Best Regards
Komuro

