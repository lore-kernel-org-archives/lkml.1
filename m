Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZGUVU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZGUVU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbZGUVU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:20:56 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2235 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZGUVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:20:55 -0400
Subject: [RFC] move __devinit or __init printk constant format strings to
 __devinitconst or __initdata?
From: Joe Perches <joe@perches.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, Matt Mackall <mpm@selenic.com>,
       Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 14:20:53 -0700
Message-Id: <1248211253.31365.337.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is moving constant string formats to __devinitconst or __initdata
useful for embedded environments?

As in:

#define printk_section(section, fmt, ...)				\
({ static const section char __fmt[] = fmt; printk(__fmt, ##__VA_ARGS__); })

#define pr_err_section(section, fmt, ...) \
	printk_section(section, KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)

with a use of:

static int __devinit foo_probe(struct platform_device *pdev)
{
	if (bar())
		pr_err_section(__devinitconst,
			       "A long error message\n");
}

or

static int __init foo_init(struct platform_device *pdev)
{
	if (bar())
		pr_err_section(__initdata,
			       "A long error message\n");
}


