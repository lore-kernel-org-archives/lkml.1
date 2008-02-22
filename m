Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYBVUnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYBVUnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYBVUnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:43:17 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52876 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYBVUnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:43:16 -0500
Date: Fri, 22 Feb 2008 21:43:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] hpt366: fix section mismatch warnings
Message-ID: <20080222204327.GH7154@uranus.ravnborg.org>
References: <20080222194651.GA7154@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222194651.GA7154@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1570,11 +1570,13 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
>  		if (rev < 3)
>  			info = &hpt36x;
>  		else {
> -			static const struct hpt_info *hpt37x_info[] =
> -				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
> -
> -			info = hpt37x_info[min_t(u8, rev, 6) - 3];
> -			idx++;
> +			switch (min_t(u8, rev, 6) - 3) {
> +			case 0: info = &hpt370;  break;
> +			case 1: info = &hpt370a; break;
> +			case 2: info = &hpt372;  break;
> +			case 3: info = &hpt372n; break;
> +			}
> +		idx++;
>  		}

I kept the calculation as it was before but the '- 3'
is not needed. So it could be fixed and the case N:
should then be updated.
[Thanks to Sergei to not this]

Another note: The warnings were seen with a
make CONFIG_DEBUG_SECTION_MISMATCH=y build so they most likely
does not show up duing a typical build due to the inlining performed
by gcc.

	Sam
