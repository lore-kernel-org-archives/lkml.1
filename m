Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZA2O2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZA2O2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZA2O2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:28:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbZA2O2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:28:04 -0500
Date: Thu, 29 Jan 2009 15:27:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] CONFIG_I2C_VIAPRO=y breaks skge
Message-ID: <20090129142759.GR24391@elte.hu>
References: <20090127151359.GA20369@elte.hu> <20090127162729.50cd2e61@hyperion.delvare> <20090127154410.GA24470@elte.hu> <20090127182631.13568383@hyperion.delvare> <20090129134916.GK24391@elte.hu> <20090129151535.2fb84505@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129151535.2fb84505@hyperion.delvare>
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

> On Thu, 29 Jan 2009 14:49:16 +0100, Ingo Molnar wrote:
> > 
> > * Jean Delvare <khali@linux-fr.org> wrote:
> > > Well my guess is that you have included an I2C chip driver with a weak 
> > > detection routine. More likely this is a typical case of "if it hurts, 
> > > don't do it". But maybe we can improve the help text or default, or even 
> > > disable probing for these devices.
> > > 
> > > At this point I am reasonably certain that the i2c-viapro driver is 
> > > innocent.
> > 
> > i've excluded the VIAPRO driver on that box (and only the VIAPRO driver - 
> > i.e. all those other I2C drivers still run frequently) - and the problem 
> > has not reoccured in about ~1000 bootups.
> > 
> > Combined with the fact that this box has a VIA chipset, does that not 
> > implicate the viapro driver, at least to a certain degree?
> 
> This VIA chipset is the bridge over which the bugs run. Blaming on it 
> for the problem you've hit would be similar to blaming the USB host 
> controller driver for a bug that is in the USB keyboard or mouse driver.
> 
> The "other I2C drivers" don't run frequently at all now that you've 
> disabled i2c-viapro. Without an I2C bus to probe on the machine, these 
> drivers don't do anything.

ah, okay - i see - what i thought to be a surgical workaround has cut off 
the whole leg. Will go back to find the ailing muscle instead.

> So, again, if you are still willing to help me solve the problem, please 
> boot the bad kernel and run:
> 
> $ ls -l /sys/bus/i2c/devices/*/driver
> 
> Then we'll know which drivers attached to I2C devices on your SMBus. 
> Figuring out which one shouldn't have will likely be straightforward.

will take some time - but i'll revisit it.

Could you give me a short list of I2C driver .config options i should 
disable one by one (instead of viapro) ?

	Ingo
