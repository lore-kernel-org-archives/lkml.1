Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbYG1Vag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbYG1Vag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYG1Va2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:30:28 -0400
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:45473 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751323AbYG1Va1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:30:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=W0EUrJe90Iq4LsdbthmpeOdqo9ygKgli1R4KL0xdkddxLKx37qt3KWzgsq4WUqwvdGoj0oL2OX/8ZHfxqdIet7E84CXTl76ppgYh8FrJ71vMV1uYFg+D1AK6zp5Mkke2;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/3] PCI: Handle 64-bit resources better on 32-bit machines
Date: Mon, 28 Jul 2008 14:30:20 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <willy@linux.intel.com>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-3-git-send-email-matthew@wil.cx>
In-Reply-To: <1217266741-26519-3-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281430.20687.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2008 10:39 am Matthew Wilcox wrote:
> If the kernel is configured to support 64-bit resources on a 32-bit
> machine, we can support 64-bit BARs properly.  Just change the condition
> to check sizeof(resource_size_t) instead of BITS_PER_LONG.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/pci/probe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 3b690c3..2036300 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -270,10 +270,10 @@ static int __pci_read_base(struct pci_dev *dev, enum
> pci_bar_type type, if (!sz64)
>  			goto fail;
>
> -		if ((BITS_PER_LONG < 64) && (sz64 > 0x100000000ULL)) {
> +		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
>  			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
>  			goto fail;
> -		} else if ((BITS_PER_LONG < 64) && l) {
> +		} else if ((sizeof(resource_size_t) < 8) && l) {
>  			/* Address above 32-bit boundary; disable the BAR */
>  			pci_write_config_dword(dev, pos, 0);
>  			pci_write_config_dword(dev, pos + 4, 0);

Both this and 1/3 look good, I've applied them to my for-linus tree.  I'll 
push them out after a little testing.

3/3 also looks nice; is there any in-tree code that could be converted over to 
using it?  If not, we can just push it as part of Eric's stuff.

Thanks,
Jesse
