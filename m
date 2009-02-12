Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZBLGDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZBLGDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZBLGD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:03:29 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44071 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750742AbZBLGD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:03:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kqY+m1q9jnxjTlZHmD6r+N2E9FbbLp55s6zraYS3c49sDmC9BAyhPX9KuxiACMmGE8FKlL0hu+QP7/E0WlGibR/OFEOCeRHUIfP5igbQMYG/j9QR3nFHXiL9/uzn77OAOdtc/GLb3AcWyUDfdsSxf6i4NpPr+1NBNZUJ+IZqXMc=  ;
X-YMail-OSG: HBOtWtkVM1kWaUy_0bfjgZ_d4qB5XLUSEct8jI2P0RdMyqR0xlStYYN1EfaHp3N6Q_X1waJvlWbzkVCpQaBWA4.UQak9ebt.Ryhpp2wQkficx0OAGA5T270nBYTYpenibyJkSw0WKRbGZ4ZFLB6M1bP4
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] usb: musb: - kill the compile warning
Date: Wed, 11 Feb 2009 22:03:25 -0800
User-Agent: KMail/1.9.10
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
References: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902112203.25428.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, Bryan Wu wrote:
> -       return (MUSB_BUSCTL_OFFSET(i, 0) + mbase);
> +       return (void __iomem *)(MUSB_BUSCTL_OFFSET(i, 0) + mbase);

Why is MUSB_BUSCTL_OFFSET() returning something other than
an integer?  "mbase" is already "void __iomem *", so the only
way that should trigger a warning is if that OFFSET() macro
is doing something odd.
