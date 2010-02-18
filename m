Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab0BRVpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:45:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53096 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754186Ab0BRVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:45:42 -0500
Date: Thu, 18 Feb 2010 21:44:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libata: pass host flags into
 __ata_pci_sff_init_one() helper
Message-ID: <20100218214448.692552fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100218185922.16594.98925.sendpatchset@localhost>
References: <20100218185914.16594.61415.sendpatchset@localhost>
	<20100218185922.16594.98925.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 19:59:22 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] libata: pass host flags into __ata_pci_sff_init_one() helper
> 
> This was orginally proposed by Alan Cox but as a change
> for ata_pci_sff_init_one() helper function instead of
> __ata_pci_sff_init_one() one which casues needless churn
> to all host drivers and accidentally breakes few host
> drivers which are still on their way upstream.
> 
> Allows parallel scan and the like to be set without
> having to stop using the existing full helper functions.

NAK - __ is for internal symbol names.

I was split 50/50 on adding ata_pci_sff_init_one_flags() or similar but
the churn, given its a one off and we can then add all sorts of other
future flags without pain, seemed worth it.

I'm ambivalent about whether its best to go with a new function name as
you have or take the hit now (which seems sensible to me). Either way the
__ naming is wrong for an external interface.

Anyway I'd *hope* we can get > 50% of interfaces parallel scanning at
which point it ceases to be more noise anyway !

Jeff ?
