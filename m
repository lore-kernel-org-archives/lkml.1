Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZFOXiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZFOXiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFOXiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:38:04 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:34269 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750901AbZFOXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:38:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G83WtMAISn4zUglju4C71Tez3OPZlnUzq9CWimMEPkbKhQJC3gJmxc9IqcZoeXiV47C0vrdcaclpgz4RoOzKLaUiWfJ0FXjK+U6VX3CiZ7WFo8ChOm2VL8+s+iipHg/TZ9JaSX0XVeplGPF1lqq7LQznChnhpPgNhkxZdLqo3xg=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: TAYEOA4VM1mDCtMfTW1oGYnBlEcbGuHB.oE3q0HdgyHGt11WWCMZJOypQ0nNzlkNxDAZbrMmhW8izUUOVdiW_iyZhB1v7XEyviNMAhTb3NLj6aH9oO5cLu0Nzm3Jz4bRb31x3pJff_6butFORg6SDoq1LprPkx6_P3RRw4xXkPyMhTbVIr.MmOlsRFUIvtVKY1Z5i.DRaP_ZnKn4vFf9fYFKMtNM9H26drnargtJQrh_3SpCZ1g1JSCFPbYNcladdC7i5T50CqduLFE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3] gpio: driver for PrimeCell PL061 GPIO controller
Date: Mon, 15 Jun 2009 16:38:04 -0700
User-Agent: KMail/1.9.10
Cc: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <1243975690-12073-1-git-send-email-baruch@tkos.co.il> <20090604092835.GJ29926@n2100.arm.linux.org.uk>
In-Reply-To: <20090604092835.GJ29926@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906151638.05008.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Russell King - ARM Linux wrote:
> > +static unsigned int pl061_irq_startup(unsigned irq)
> > +{
> > +     int ret;
> > +
> > +     ret = gpio_request(irq_to_gpio(irq), "IRQ");
> > +     if (ret < 0) {
> > +             pr_warning("%s: warning: gpio_request(%d) returned %d\n",
> > +                             __func__, irq_to_gpio(irq), ret);
> > +             return 0;
> > +     }
> > +
> > +     gpio_direction_input(irq_to_gpio(irq));
> 
> I thought that it was not expected that claiming an interrupt would claim
> a GPIO automatically - in other words, it's the responsibility of the
> driver or platform itself to claim GPIOs for interrupts and ensure that
> they're properly configured.

You're right about that.

