Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZGUV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZGUV5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZGUV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:57:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2278 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZGUV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:57:07 -0400
Subject: Re: [RFC] move __devinit or __init printk constant format strings
 to __devinitconst or __initdata?
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1248212925.10466.143.camel@calx>
References: <1248211253.31365.337.camel@Joe-Laptop.home>
	 <1248212925.10466.143.camel@calx>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 14:56:43 -0700
Message-Id: <1248213403.31365.343.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 16:48 -0500, Matt Mackall wrote:
> On Tue, 2009-07-21 at 14:20 -0700, Joe Perches wrote:
> > Is moving constant string formats to __devinitconst or __initdata
> > useful for embedded environments?
> > As in:
> > #define printk_section(section, fmt, ...)				\
> > ({ static const section char __fmt[] = fmt; printk(__fmt, ##__VA_ARGS__); })
> > #define pr_err_section(section, fmt, ...) \
> > 	printk_section(section, KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> > with a use of:
> > static int __devinit foo_probe(struct platform_device *pdev)
> > {
> > 	if (bar())
> > 		pr_err_section(__devinitconst,
> > 			       "A long error message\n");
> > }

> Interesting notion, but not worth the trouble in my mind. I think it's
> more worthwhile to look into automatic such stuff in the build somehow.

I think it's not possible today to get gcc to mark
the format strings without source modification.

It's pretty easy to script a source conversion.

