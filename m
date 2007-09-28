Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXI1KX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXI1KX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXI1KXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:23:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59289 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752429AbXI1KXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:23:18 -0400
Date: Fri, 28 Sep 2007 11:27:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata drain fifo on stuck DRQ HSM violation
Message-ID: <20070928112735.264733ad@the-village.bc.nu>
In-Reply-To: <46FC7B72.2030103@rtr.ca>
References: <46CFA08E.6090604@arbores.ca>
	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>
	<46DBCB6C.8080206@gmail.com>
	<20070905095327.6277d054.akpm@linux-foundation.org>
	<46DEE617.4050004@rtr.ca>
	<46E0A253.7060803@gmail.com>
	<46E154DE.2060602@rtr.ca>
	<46FB563A.80108@gmail.com>
	<20070927193701.6230d77f@the-village.bc.nu>
	<46FC3D7D.90009@gmail.com>
	<46FC3FDD.5060201@pobox.com>
	<46FC423C.2050206@gmail.com>
	<46FC7B72.2030103@rtr.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Drain up to 512 words from host/bridge FIFO on stuck DRQ HSM violation,
> rather than just getting stuck there forever.

Why 512 words ?


>  	ata_altstatus(ap);
> -	ata_chk_status(ap);
> +	ata_drain_fifo(ap, qc);

ap->ops->cleanup();

might be wiser
