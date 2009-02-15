Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZBOTs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZBOTs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZBOTsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:48:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54229 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZBOTsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:48:17 -0500
Message-ID: <4998717A.2090507@pobox.com>
Date: Sun, 15 Feb 2009 14:48:10 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 resend] libata-sff: avoid byte swapping in ata_sff_data_xfer()
References: <200902152230.38271.sshtylyov@ru.mvista.com>
In-Reply-To: <200902152230.38271.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Handling of the trailing byte in ata_sff_data_xfer() is suboptimal bacause:
> 
> - it always initializes the padding buffer to 0 which is not really needed in
>   both the read and write cases;
> 
> - it has to use memcpy() to transfer a single byte from/to the padding buffer;

Have you looked at the assembly, before deciding it is suboptiomal?

gcc optimizes tiny arrays and structures quite well, and is well capable 
of seeing one path where the initialization is clobbered without a 
single read, and another code path where it is used.

As for memcpy, for small and/or constant values that is quite often a 
compiler builtin.  It is rarely useful, these days, to convert a 
memcpy() to a hand-rolled version of same.

	Jeff



