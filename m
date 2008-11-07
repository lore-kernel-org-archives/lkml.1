Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYKGW5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYKGW5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYKGW5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:57:02 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:20520 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750904AbYKGW5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:57:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vx6fcJuASXzs+pWXKVWZmUjkuTlwh2IZ5z9LpB87snyUaj0D21ZbbTj1nlSOFQNCLdGynfJUXCe71DaoL4mlockAIBrMV6kRJs3CDfDlkNq4HHPjRbfg0E9KOGlQ8vWwGGLEkTeHkxClvWnKrkEIPA02NUHygB5k7saNvveWjX0=  ;
X-YMail-OSG: rTR7gyEVM1mD2V0JN3VOJA_YQL3Y36CTKaLfYfS8uXk9Pr5N9zZUArjgzkyJ2uxxTq.wT5mMyX9jqahXciDQWhwulNnZ8sxFw.ZOIPryGxK3WDB2psJEoj9dyPwL286ZIgU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Date: Fri, 7 Nov 2008 14:56:58 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
References: <200809241251.32606.david-b@pacbell.net> <200810111101.20885.david-b@pacbell.net> <20081012144638.4dfdbff8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081012144638.4dfdbff8@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071456.58921.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008, Haavard Skinnemoen wrote:
> I just want a mechanism where you'll end up with the same behaviour
> regardless of what the hardware supports, at the cost of a timer if the
> hardware doesn't support the requested debounce delay. As an added
> benefit, this would eliminate the need for drivers to set up their own
> debounce timers. It would also make such "more powerful" hardware
> features easier to utilize from generic drivers, wouldn't it?
> 
> But you've convinced me that your IRQF_DEBOUNCE hint might be useful
> too.

Just for the record ... I'm withdrawing this proposal, in the sense
that I won't be pursuing it any further.  A lighter weight solution
is enough for now.

I think the framework we discussed -- lowlevel irq_chip mechanism
that can kick in hardware debouncing and report the duration of its
debounce delay, paired with upper level code that can kick in longer
software timers as needed -- is probably the right direction to go,
if anyone really needs this.


> > If the platform setup code knows the hardware debounce will
> > be requested, it can adjust its platform_data debounce parameter
> > accordingly.
>
> I guess it could, but why would it do that? The debounce delay
> shouldn't depend on the mechanism used to implement it, should it?

The overall delay shouldn't matter, no.  But if an 10 msec hardware
debounce kicks in and you wanted 20 msec total, you'd want something
to conclude that a 10 msec software timer is more appropriate than
a 20 msec one.  I was pointing out that in one construction, that
"something" would be platform setup code which knows more about how
the system is set up than a "dumb" software timer in that driver.

- Dave

