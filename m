Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZKGLUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZKGLUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 06:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZKGLUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 06:20:04 -0500
Received: from relay.atmel.no ([80.232.32.139]:51557 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZKGLUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 06:20:02 -0500
Date: Sat, 7 Nov 2009 12:20:02 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       David Brownell <dbrownell@users.sourceforge.net>, kernel@avr32linux.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Victor <avictor.za@gmail.com>, akpm@linux-foundation.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc driver in
 at91sam9g45 chip and board
Message-ID: <20091107122002.1ecf6483@hskinnemoen-d830>
In-Reply-To: <1257216943.4358.66.camel@ben-desktop>
References: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>
	<20090930155557.7dae503b@hskinnemoen-d830>
	<a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>
	<cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>
	<20091028083548.38f1d80c@hskinnemoen-d830>
	<d6cda7730910271753o54acfa04t1225de460083325f@mail.gmail.com>
	<cd73a99e0910281253x1bb72b74p47cb5110efb0871f@mail.gmail.com>
	<1256763057.4362.36.camel@ben-desktop>
	<4AEF12B7.3040704@atmel.com>
	<4AEF95E0.7040602@bluewatersys.com>
	<1257216943.4358.66.camel@ben-desktop>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette <bn@niasdigital.com> wrote:
> On Tue, 2009-11-03 at 15:30 +1300, Ryan Mallon wrote:
> > >   
> > IIRC, we can't mark static inline functions as weak, and we don't want
> > to turn gpio_is_valid into an actual function call. We could do some
> > preprocessor magic, but that gets a bit messy.  
> 
> Messy but generally accepted.

IIRC the most generally accepted way is to do

static inline bool gpio_is_valid(int pin)
{
	/* whatever */
}
#define gpio_is_valid gpio_is_valid

in the platform code and

#ifndef gpio_is_valid
/* provide definition of gpio_is_valid */
#endif

in the generic code. This way, there's only one symbol to grep for.

Haavard
