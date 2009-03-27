Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZC0KZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZC0KZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZC0KZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:25:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46587 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753007AbZC0KZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:25:30 -0400
Date: Fri, 27 Mar 2009 10:26:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: davem@davemloft.net
Subject: Re: ax25: zero length frame filtering in AX25
Message-ID: <20090327102624.16e06404@lxorguk.ukuu.org.uk>
In-Reply-To: <200903270102.n2R12Q9f021549@hera.kernel.org>
References: <200903270102.n2R12Q9f021549@hera.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     In previous commit 244f46ae6e9e18f6fc0be7d1f49febde4762c34b
>     was introduced a zero length frame filter for ROSE protocole.
>     This patch has the same purpose at AX25 frame level for the same
>     reason. Empty frames have no meaning in AX25 protocole.

That isn't actually true. A zero (user data) length AX.25 frame has
meaning because AX.25 is a LAPB variant so preserves frame boundaries. In
AX.25 a 0 length write and read are both legitimate activities even if
the socket API has a problem with it. Viz a 0 length send causes a 0
length receive which is passing a message boundary.

This code is even more wrong because it is applied to both datagram and
sequenced connections. In datagram mode a zero data frame most definitely
has meaning, is valid in both directions and can be used very
successfully for beaconing (indicating your presence)

(Fortunately the socket API can handle this as the DECnet folks at
Digital discovered and documented)

Alan
