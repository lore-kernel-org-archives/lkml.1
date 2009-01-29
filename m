Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZA2Ntf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZA2Ntf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZA2NtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:49:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZA2NtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:49:24 -0500
Date: Thu, 29 Jan 2009 14:49:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] CONFIG_I2C_VIAPRO=y breaks skge
Message-ID: <20090129134916.GK24391@elte.hu>
References: <20090127151359.GA20369@elte.hu> <20090127162729.50cd2e61@hyperion.delvare> <20090127154410.GA24470@elte.hu> <20090127182631.13568383@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127182631.13568383@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Delvare <khali@linux-fr.org> wrote:

> > > What I2C chip drivers did you include in your kernel? Presumably 
> > > this is a random config, so I can imagine that there is a chip on 
> > > the SMBus to which an I2C chip driver would have bound and that is 
> > > causing the problem, rather than i2c-viapro itself.
> > 
> > Correct, i found it via random config testing. x86 defconfig + VIAPRO 
> > enabled boots fine so it indeed could be interaction between i2c 
> > drivers.
> 
> Is there anything like a x86 defconfig? I didn't know. [...]

Yes. Type "make defconfig" in the kernel source top directory, on an x86 
box.

> > Anyway, this bug is not a big deal - i can work it around locally by 
> > excluding VIAPRO on that box. If you'd like to figure out why this 
> > happens that would be preferred of course, and i can send any debug 
> > info you need.
> 
> Well my guess is that you have included an I2C chip driver with a weak 
> detection routine. More likely this is a typical case of "if it hurts, 
> don't do it". But maybe we can improve the help text or default, or even 
> disable probing for these devices.
> 
> At this point I am reasonably certain that the i2c-viapro driver is 
> innocent.

i've excluded the VIAPRO driver on that box (and only the VIAPRO driver - 
i.e. all those other I2C drivers still run frequently) - and the problem 
has not reoccured in about ~1000 bootups.

Combined with the fact that this box has a VIA chipset, does that not 
implicate the viapro driver, at least to a certain degree?

	Ingo
