Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZKDJ4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZKDJ4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZKDJ4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:56:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56740 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751012AbZKDJ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:56:53 -0500
Date: Wed, 4 Nov 2009 09:58:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Hal Finney <hal.finney@gmail.com>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
 multiple times
Message-ID: <20091104095814.13435621@lxorguk.ukuu.org.uk>
In-Reply-To: <13189.1257305069@turing-police.cc.vt.edu>
References: <20091103003511.GL7768@obsidianresearch.com>
	<da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com>
	<6926.1257272068@turing-police.cc.vt.edu>
	<20091103224157.GA20963@obsidianresearch.com>
	<13189.1257305069@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> but those are hard-coded into the driver. But for the TPM, it's unclear if
> exclusive or non-exclusive is the right model. Maybe the right answer is to
> default to multiple opens, but have an ioctl() that turns on exclusive mode.
> If you have a 'tcsd' daemon, it will need to get launched early enough
> to do the open/ioctl before somebody else gets running anyhow, so it's
> not adding to any raciness.  Yeah, it's a hack. And there's still a small
> DoS issue - if the system is supposed to allow multiple opens, an abusive
> process can ioctl() it and break it.

What's wrong with "chmod" ?

BTW some drivers do also implement O_EXCL = one open semantics. It's not
exactly what POSIX expects but these are drivers and its a fairly logical
extension thereto.

Alan
