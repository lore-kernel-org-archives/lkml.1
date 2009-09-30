Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZI3Ua0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZI3Ua0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZI3UaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:30:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60978 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752001AbZI3UaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:30:25 -0400
Date: Wed, 30 Sep 2009 21:31:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: leitao@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jsm: fixing termios structure to be compatible with
 stty application
Message-ID: <20090930213140.4172748f@lxorguk.ukuu.org.uk>
In-Reply-To: <1254327512-6880-1-git-send-email-leitao@linux.vnet.ibm.com>
References: <1254327512-6880-1-git-send-email-leitao@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +	termios->c_ispeed = termios->c_cflag & CBAUD;
> +	termios->c_ospeed = termios->c_cflag & CBAUD;
> +

NAK

termios->c_ispeed/ospeed are the actual baud rates not bit encodings, and
are used for devices that support arbitary speeds

Use

	tty_termios_encode_baudrate(termios, ispeed, ospeed);

where ispeed/ospeed are actual input and output baud.

It does all the hard work and knows about

- keeping requests for traditional style B38400 type requests in their
  native form (so a request for 38400 that comes out at 38100 will still
  get encoded as B38400)
- Encoding arbitary rates using BOTHER
- Handling platforms that haven't been updated properly.


The patch you posted is a nonsense patch so if it helps it might be worth
looking harder as to why..

Alan
