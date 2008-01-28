Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYA1Jl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYA1Jl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYA1JlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:41:18 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:40019 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750788AbYA1JlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:41:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X7MyMp2fa62CsP3mfWaBdxP25fgTnxdAIys6v66U52fwNoTXi6Xsm3Dkdid3DmCpPE3FVLTdF0yLjcya8p0AjZcyM0VqeKrxejHTw+UnRQjx8kqXxzOuo0N0G0lytSJk59mK9EKpMWXVxzUiv0c2ofDO009cbQqokrJC7qwRMOg=  ;
X-YMail-OSG: bUAyKIYVM1kqJTGceDHDG_QiIpRszju39NvCdNInoGdaTDY9tjV2E605yL5BvhRx9DTQ6zw7VQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 2/2] PWM LED driver
Date: Mon, 28 Jan 2008 01:41:11 -0800
User-Agent: KMail/1.9.6
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com> <20080128101551.7cbc7af5@dhcp-252-066.norway.atmel.com> <20080128012932.bfbbd97d.akpm@linux-foundation.org>
In-Reply-To: <20080128012932.bfbbd97d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801280141.12424.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Andrew Morton wrote:
> > -     if (i > 0) {
> > -             for (i = i - 1; i >= 0; i--) {
> > -                     led_classdev_unregister(&leds[i].cdev);
> > -                     pwm_channel_free(&leds[i].pwmc);
> > -             }
> > +     while (i-- > 0) {
> > +             led_classdev_unregister(&leds[i].cdev);
> > +             pwm_channel_free(&leds[i].pwmc);
> >       }
> 
> Looks OK, although I'd say that `while (--i >= 0)' is more idiomatic -
> predecrement, postincrement and all that?

Except for the "unsigned i;" declaration earlier... given that,
"while (true) cpu_relax();" becomes maximally idiomatic.  :)

Odd how PDP-11 idioms linger.  Just because C was designed on
that processor ...


