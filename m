Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbXKFVFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbXKFVFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXKFVE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:04:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXKFVE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:04:59 -0500
Message-ID: <4730D6F3.8030500@redhat.com>
Date: Tue, 06 Nov 2007 22:04:51 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, list+2007@smokva.net
Subject: Re: dd/mke2fs on loopback hangs
References: <20071106131310.GA8628@pintail.smokva.net>
In-Reply-To: <20071106131310.GA8628@pintail.smokva.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petar Bogdanovic wrote:
> I experience some strange problems with my loopback-on-ext3-setup.
> After creating a plain `zeroed' dummy-file and doing a /dev/loop/0 on
> it, every dd or mke2fs hangs while doing certain write()s. Here are the
> steps just in order to show, how simple the setup is:
...

> P.S:	$ uname -a
> 	Linux pintail 2.6.23-ARCH #1 SMP PREEMPT Sat Oct 27 09:04:14 UTC
> 	2007 i686 Intel(R) Pentium(R) M processor 1.70GHz GenuineIntel
> 	GNU/Linux

Hi Petar,

I saw similar bug report for dm-crypt over loop but reproducible even
on stand-alone loop devices -  see http://bugzilla.kernel.org/show_bug.cgi?id=8020

The problem was caused by loop io stalling in balance_dirty_pages.

Per BDI dirty limit patchset (included in 2.6.24-rc) fixed it.

Anyway, you should attach output of process states when system stops
responding (output of "echo t >/proc/sysrq-trigger" ) here to allow
some analysis.

Milan
--
mbroz@redhat.com


