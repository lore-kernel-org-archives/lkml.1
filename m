Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbXLZWuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbXLZWuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 17:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXLZWuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 17:50:25 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61850 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751712AbXLZWuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 17:50:24 -0500
Date: Wed, 26 Dec 2007 23:50:12 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Correct use of __init and __devinit
Message-ID: <20071226235012.04373e0d@siona>
In-Reply-To: <20071224130143.GA27530@uranus.ravnborg.org>
References: <8b67d60712230856o73bc89d7u142b93fc47b7533b@mail.gmail.com>
	<20071224130143.GA27530@uranus.ravnborg.org>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007 14:01:43 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> So of the principle of least suprise it is best to use __devinit
> for the probe function as most other drivers do. And if
> the driver model happens to call your probe function after
> init time then we will not oops.

If you're dealing with platform_devices, you can use
platform_driver_probe() and remove the probe() function from the
platform_driver struct to ensure this never happens.

This is only ok for non-hotpluggable devices, of course.

Haavard
