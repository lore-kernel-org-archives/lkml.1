Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZJ1Uui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZJ1Uui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZJ1Uuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:50:37 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:41937
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbZJ1Uuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:50:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUBABpL6Ep8qNN0/2dsb2JhbAAI2nOEPwQ
X-IronPort-AV: E=Sophos;i="4.44,641,1249228800"; 
   d="scan'208";a="575014213"
Subject: Re: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc driver in 
 at91sam9g45 chip and board
From: Ben Nizette <bn@niasdigital.com>
To: Andrew Victor <avictor.za@gmail.com>
Cc: "Thiago A." =?ISO-8859-1?Q?Corr=EAa?= <thiago.correa@gmail.com>,
       kernel@avr32linux.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <cd73a99e0910281253x1bb72b74p47cb5110efb0871f@mail.gmail.com>
References: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>
	 <20090930155557.7dae503b@hskinnemoen-d830>
	 <a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>
	 <cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>
	 <20091028083548.38f1d80c@hskinnemoen-d830>
	 <d6cda7730910271753o54acfa04t1225de460083325f@mail.gmail.com>
	 <cd73a99e0910281253x1bb72b74p47cb5110efb0871f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 07:50:57 +1100
Message-Id: <1256763057.4362.36.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 21:53 +0200, Andrew Victor wrote:
> hi,
> 
> > Then I think it would be best to use GPIO_PIN_NONE. Makes it clear
> > what is expected and avoids confusion on what should be the proper
> > value.
> > I hope I'm not saying non-sense, but even if I am, I guess you can see
> > that I'm advocating against the magic numbers :)
> 
> What magic numbers ?

I think Thiago was referring to the "-1" in the original patch as the
magic number.

Leaving the field blank to be initialised to 0 is certainly the
cleanest, I agree, but it doesn't actually /work/.  On many archs 0 is a
valid gpio number; the gpio_is_valid check used throughout the kernel
(including atmel-mci.c) looks like

static inline int gpio_is_valid(int number)
{
	/* only some non-negative numbers are valid */
	return ((unsigned)number) < ARCH_NR_GPIOS;
}

	--Ben.

