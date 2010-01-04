Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534Ab0ADPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0ADPJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519Ab0ADPJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:09:34 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:51202 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0ADPJd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Jan 2010 10:09:33 -0500
Date: Mon, 4 Jan 2010 08:44:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/29] x86/pci: intel ioh bus num reg accessing fix
Message-ID: <20100104134456.GB16706@phenom.dumpdata.com>
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org> <1262574307-17040-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262574307-17040-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B42045E.0262:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 07:04:40PM -0800, Yinghai Lu wrote:
> it is above 0x100, so if mmconf is not enable, need to skip it
> 
> Reported-by: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/pci/intel_bus.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
> index b7a55dc..baf283a 100644
> --- a/arch/x86/pci/intel_bus.c
> +++ b/arch/x86/pci/intel_bus.c
> @@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(struct pci_dev *dev)
>  	u64 mmioh_base, mmioh_end;
>  	int bus_base, bus_end;
>  
> +	/* some sys doesn't get mmconf enabled */
> +	if (dev->cfg_size < 0x200)

Here we check under the 512 index.. but the comment states
that the check should be above 256 index? Should the comment say
"it is above 0x200, so if mmconf.."?
