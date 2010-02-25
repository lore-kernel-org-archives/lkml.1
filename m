Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0BYNFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:05:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57548 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932383Ab0BYNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:05:15 -0500
Date: Thu, 25 Feb 2010 13:08:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vb@vsbe.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: "irq 42: nobody cared" and I/O errors on serial ports
Message-ID: <20100225130856.40a3b206@lxorguk.ukuu.org.uk>
In-Reply-To: <f608b67d1002241739o2668b93cuc9eea669f70a407d@mail.gmail.com>
References: <f608b67d1002241739o2668b93cuc9eea669f70a407d@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> what would be a proper fix here - should
> serial_core.c:uart_unthrottle() be modified not to attempt sending a
> character on the disabled tty?

n_tty should not be calling the in the buffer flush handling when it is
closed. Known bug. It needs to reset the flags but shouldn't be
restarting I/O from that path.



