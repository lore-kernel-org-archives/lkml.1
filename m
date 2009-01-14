Return-Path: <linux-kernel-owner+w=401wt.eu-S1762841AbZANPVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762841AbZANPVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZANPVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:21:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55487 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753688AbZANPVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:21:33 -0500
Date: Wed, 14 Jan 2009 15:21:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Pierre Habouzit <pierre.habouzit@intersec.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: if backlog is 0, listening shall not be
 deactivated.
Message-ID: <20090114152133.675da27b@lxorguk.ukuu.org.uk>
In-Reply-To: <496DEA60.2080700@hp.com>
References: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>
	<496DE5ED.8030609@hp.com>
	<20090114132124.15b68481@lxorguk.ukuu.org.uk>
	<496DEA60.2080700@hp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SCTP API simply chooses to ignore the "may".  It is still fully compliant
> with POSIX in this regard.

Linux chooses the interpretation that zero means one connection. Having a
single protocol variant do different things is not nice because  a lot
of code is designed to handle multiple address families and expect the
same non address handling behaviour.

So while it may be able to claim posix compliance, its not Linux
behaviour, and its relying on a specific interpretation of posix not
being used by the OS.

At the very least the current behaviour of the SCTP code is plain rude.
