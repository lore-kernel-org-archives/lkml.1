Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYFBRV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYFBRV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYFBRVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:21:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:59728 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751892AbYFBRVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:21:49 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+laO5rRval4HuIzcJNGPTVpRA2uIMxKGc6u6jCs5
	YgfIyIWNKO7LoJ
Date: Mon, 2 Jun 2008 19:22:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: [RFC] generic GPIO parameter API
Message-ID: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as far as I understand, the current GPIO API only presents very basic GPIO 
functionality: direction and level reading and writing. Whereas many GPIO 
controllers have many further configurable parameters: pull-ups and 
pull-downs, drive strength, slew rate, etc. And it is desirable to be able 
to access those features too. Of course, we cannot extent the API with all 
these possible functions. Would a generic GPIO parameter handling API be 
desirable? Like

struct gpio_parameter {
	char *name;
	void *arg;
	int (*get)(struct gpio_chip *chip, void *arg, unsigned offset, 
			int value);
	int (*set)(struct gpio_chip *chip, void *arg, unsigned offset, 
			int value);
};

int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
				*param);
struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
						*name);

The parameters should be accessible from the kernel and over sysfs, based 
on the gpio-sysfs interface. Would this be useful?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
