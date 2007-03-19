Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbXCSLoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbXCSLoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbXCSLo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:44:29 -0400
Received: from [81.2.110.250] ([81.2.110.250]:42683 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753468AbXCSLo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:44:29 -0400
Date: Mon, 19 Mar 2007 12:46:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Tony Vroon <chainsaw@gentoo.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22] Add LED trigger to libata core
Message-ID: <20070319124616.2fb7494b@lxorguk.ukuu.org.uk>
In-Reply-To: <45FE14BD.5090701@gmail.com>
References: <20070318170605.3751D5B80F1@ganymede.vroon.org>
	<45FE14BD.5090701@gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 13:42:37 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Tony Vroon wrote:
> > This duplicates the IDE core LED trigger in the libata core.
> > I plan to use this by allowing PMU LED control on G5 towers. My test platform 
> > is a PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.
> 
> I think this fits better in libata-core.c::ata_qc_issue().  Can you move
> it to there?

Gak. I'd rather it stayed out of ata_qc_issue() which is a critical path
for performance. Our command issu is already too heavy and not all
controllers have queueing to absorb that. How many controllers actually
need this hook and can we not have ata_qc_issue_with_led() helpers for
them ?
