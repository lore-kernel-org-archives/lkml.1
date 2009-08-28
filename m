Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZH1FqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZH1FqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZH1FqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:46:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:45439 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZH1FqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:46:23 -0400
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <4B4F10E3-C09C-4C26-9D42-4CC297021F0F@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090818220415.GB25090@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 2/8] powerpc/qe&cpm2: Avoid redefinitions in CPM2 and QE headers
Date: Fri, 28 Aug 2009 00:45:45 -0500
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru> <20090818220415.GB25090@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18, 2009, at 5:04 PM, Anton Vorontsov wrote:

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
