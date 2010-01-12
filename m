Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414Ab0ALS4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0ALS4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187Ab0ALS4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:56:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:50411 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753028Ab0ALS4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:56:43 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19oZDNznDFoaPAkdPpziRR5d4/vvVdhuLOjkoEj5I
	UanIV0rAH5ya4J
Message-ID: <4B4CC5E5.5010200@gmx.de>
Date: Tue, 12 Jan 2010 19:56:37 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Tiago Vignatti <tiago.vignatti@nokia.com>
CC: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paulo R. Zanoni" <przanoni@gmail.com>, Henry Zhao <Henry.Zhao@Sun.COM>,
       Andy Getzendanner <james.getzendanner@students.olin.edu>,
       Brad Spengler <spender@grsecurity.net>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH] vgaarb: fix typo deference when copying from userspace
References: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
In-Reply-To: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 06:58 PM, Tiago Vignatti wrote:
> From: Brad Spengler<spender@grsecurity.net>
>
> libpciaccess is not triggering such code though.
>
> Signed-off-by: Tiago Vignatti<tiago.vignatti@nokia.com>

I can confirm, that this patch is needed to prevent a kernel
segfault with 2.6.33-rc3  on the parisc/hppa architecture.

Tested-by: Helge Deller <deller@gmx.de>

> ---
> Andy Getzendanner tried to fix this, but he seems did a wrong approach:
> http://marc.info/?l=linux-kernel&m=126112173704466
>
> Andy: please test (and put your tag review!) this one instead. Thanks.
>
>   drivers/gpu/vga/vgaarb.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index 1ac0c93..2f6cf69 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -961,7 +961,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
>   		remaining -= 7;
>   		pr_devel("client 0x%p called 'target'\n", priv);
>   		/* if target is default */
> -		if (!strncmp(buf, "default", 7))
> +		if (!strncmp(curr_pos, "default", 7))
>   			pdev = pci_dev_get(vga_default_device());
>   		else {
>   			if (!vga_pci_str_to_vars(curr_pos, remaining,

