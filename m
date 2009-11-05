Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZKENrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZKENrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZKENrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:47:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:43655 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbZKENrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:47:13 -0500
Subject: Re: [PATCH 2/8] powerpc/qe&cpm2: Avoid redefinitions in CPM2 and QE headers
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164916.GB4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:46:33 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DFC8D182-2FAD-4207-8FE0-C25DA04F2432@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164916.GB4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> struct mcc defined in both immap_qe.h and immap_cpm2.h, so they will
> conflic when included in a single file. The mcc struct is easy to deal
> with, since it isn't used in any driver (yet), so let's just rename QE
> version to qe_mcc.
>
> The ucb_ctlr is a bit trickier, since it is used by fsl_qe_udc driver,
> and the driver supports both CPM and QE UDCs, plus the QE version is
> used to form a bigger immap struct.
>
> I don't want to touch too much of USB code in this series, so for now
> let's just copy most generic version into the common cpm.h header,
> later we'll create cpm_usb.h where we'll place common USB structs that
> are used by QE/CPM UDC and QE Host drivers (FHCI).
>
> And as for the structs in qe.h and cpm2.h, just prefix them with qe_
> and cpm_.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/include/asm/cpm.h        |   22 ++++++++++++++++++++++
> arch/powerpc/include/asm/immap_cpm2.h |    2 +-
> arch/powerpc/include/asm/immap_qe.h   |    8 ++++----
> 3 files changed, 27 insertions(+), 5 deletions(-)

applied to next

- k
