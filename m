Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZGTMqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZGTMqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZGTMqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:46:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37235 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbZGTMqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:46:37 -0400
Date: Mon, 20 Jul 2009 13:47:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: arun c <arun.edarath@gmail.com>, Julia Lawall <julia@diku.dk>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 9/10] drivers/mmc: Move a dereference below a NULL test
Message-ID: <20090720134736.605f86d1@lxorguk.ukuu.org.uk>
In-Reply-To: <4A64665B.9000504@nokia.com>
References: <Pine.LNX.4.64.0907191729580.16542@ask.diku.dk>
	<4A642458.6080008@nokia.com>
	<c656a4d20907200533t1cbe1476l62d8a51fdb796c70@mail.gmail.com>
	<4A64665B.9000504@nokia.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is not a "NULL check" it is an assertion, which can be compiled out.
> On some platforms BUG is implemented as a null dereference anyway
> e.g. on ARM  it is *(int *)0 = 0;

It's a bogus check because the 

struct mmc_omap_host *host = slot->host;

has already been executed before you check for slot == NULL

