Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZLIQ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZLIQ1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZLIQ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:27:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36505 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbZLIQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:27:47 -0500
Date: Wed, 9 Dec 2009 16:29:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cypher Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Questions about Watch Dog Timer under Linux.
Message-ID: <20091209162958.3b98c077@lxorguk.ukuu.org.uk>
In-Reply-To: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> products is usually a seperate chip on the board wich will start to
> work after power reset and will time out in 2 seconds. The system has
> to start dog clearing from the very beginning and there have no way to
> disable WDT.

That will be fun as you will probably need to start some kind of kernel
task refereshing it early in boot unless your boot is very quick.

If it cannot be disabled then you don't need to support the disable
option. The watchdog API is a range of features designed to cover all
watchdogs. Many only have a few of the features. A large number of the
supported watchdogs only support a single timeout rate.

> Is this the pattern we have to follow to use WDT under Linux? We have
> to choose a chip as WDT, and it seems the chip we've familiar under
> embedded systems can't be used under Linux?

There are two ways to handle this depending on your needs and what the
applications require. The first is to provide the real hardware interface
- 2 second fixed timeout, no disable. That's perfectly sufficient.

The other (which some devices do) is to create a kernel thread that
refreshes the watchdog each second but *only* if a user application has
made a watchdog call within the last [whatever] seconds. That also allows
you to provide a disableable watchdog. More flexible but extra work and
if your embedded system doesn't need the extra facilities - why bother 8)

