Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZFYIq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZFYIq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZFYIqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:46:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38973 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZFYIqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:46:49 -0400
Date: Thu, 25 Jun 2009 09:46:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, plagnioj@jcrosoft.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       avictor.za@gmail.com
Subject: Re: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
Message-ID: <20090625084631.GA7985@n2100.arm.linux.org.uk>
References: <4A40D695.5000302@atmel.com> <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com> <20090623153556.0e574899@hskinnemoen-d830> <4A40E2E6.9060904@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40E2E6.9060904@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:12:54PM +0200, Nicolas Ferre wrote:
> Haavard Skinnemoen :
> > Nicolas Ferre wrote:
> >> +config ARCH_ATMEL_HAS_FB
> >> +	bool
> >> +	depends on FB
> >> +	default n
> > 
> > What happens when we unconditionally select something which depends on
> > something else?
> 
> :-P
> 
> Experience shows that this configuration is selected.
> 
> The dependency allows to have a good hierarchy in the configuration tree...
> Better proposition welcome.

1st - no need for 'default n' - you're specifying something that's already
the default.

2nd - don't make this symbol depend on anything, and don't use the symbol
for anything except providing a dependency for FB_ATMEL.  Instead, let
FB_ATMEL deal with the dependency on FB and ARCH_ATMEL_HAS_FB.

3rd - ISTR we have a convention for these - 'HAVE_foo' for a configuration
option named 'foo'.  So it should probably be HAVE_FB_ATMEL.
