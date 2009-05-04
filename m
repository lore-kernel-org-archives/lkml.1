Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZEDXgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZEDXgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZEDXgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:36:41 -0400
Received: from ru.mvista.com ([213.79.90.228]:12902 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754984AbZEDXgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:36:40 -0400
Date: Tue, 5 May 2009 03:36:35 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: galak@kernel.crashing.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] spi_mpc8xxx: s/83xx/8xxx/g
Message-ID: <20090504233635.GA5892@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090430234739.GA27709@oksana.dev.rtsoft.ru> <20090430234833.GI7901@oksana.dev.rtsoft.ru> <20090504135327.13cd42af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090504135327.13cd42af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 01:53:27PM -0700, Andrew Morton wrote:
> On Fri, 1 May 2009 03:48:33 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > Since we renamed the file, we might want to rename the file
> > internals too.
> > 
> > Though we don't bother with changing platform driver name and
> > platform module alias. The stuff is legacy and hopefully we'll
> > remove it soon.
> > 
> 
> but but but
> 
> >
> > -static struct of_platform_driver of_mpc83xx_spi_driver = {
> > -	.name		= "mpc83xx_spi",
> > -	.match_table	= of_mpc83xx_spi_match,
> > -	.probe		= of_mpc83xx_spi_probe,
> > -	.remove		= __devexit_p(of_mpc83xx_spi_remove),
> > +static struct of_platform_driver of_mpc8xxx_spi_driver = {
> > +	.name		= "mpc8xxx_spi",
> > +	.match_table	= of_mpc8xxx_spi_match,
> > +	.probe		= of_mpc8xxx_spi_probe,
> > +	.remove		= __devexit_p(of_mpc8xxx_spi_remove),
> >  };
> 
> It _did_ change the platform driver name, didn't it?

This is an OF platform driver, here it is safe to change
the name. But I didn't change the pure platform driver,
here:

| -static struct platform_driver mpc83xx_spi_driver = {
| -       .probe = plat_mpc83xx_spi_probe,
| -       .remove = __exit_p(plat_mpc83xx_spi_remove),
| +static struct platform_driver mpc8xxx_spi_driver = {
| +       .probe = plat_mpc8xxx_spi_probe,
| +       .remove = __exit_p(plat_mpc8xxx_spi_remove),
|         .driver = {
|                 .name = "mpc83xx_spi",

------------------^

> This patch series had quite a lot of conflicts with the already-pending
> 
> spi-move-common-spi_setup-functionality-into-core.patch
> spi-move-more-spi_setup-functionality-into-core.patch
> 
> which I beleive I successfully fixed up.

Thanks a lot, I'll test it soon.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
