Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0CEMBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:01:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56970 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258Ab0CEMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:01:01 -0500
Date: Fri, 5 Mar 2010 12:03:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: s ponnusa <foosaa@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Mark Lord <kernel@teksavvy.com>,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
 program
Message-ID: <20100305120355.6b161572@lxorguk.ukuu.org.uk>
In-Reply-To: <f875e2fe1003041811p5aa934ecob90836a8d0a6b605@mail.gmail.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	<20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	<87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
	<4B8FC6AC.4060801@teksavvy.com>
	<f875e2fe1003040733h20d5523ex5d18b84f47fee8c7@mail.gmail.com>
	<4B8FF2C3.1060808@teksavvy.com>
	<f875e2fe1003041020t7cbab2c2x585df9b2dfc10dd2@mail.gmail.com>
	<4B90655B.4000005@gmail.com>
	<f875e2fe1003041811p5aa934ecob90836a8d0a6b605@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cannot be read back by any other means. And the program which wrote
> the data is unaware of the error that has happened at the lower level.
> But the error log clearly has the issue caught but is trying to handle
> differently.

This is standard behaviour on pretty much every OS. If each write was
back verified by the OS you wouldn't get any work done due fact it took
so long to do any I/O and all I/O was synchronoous.

Where it matters you can mount some file systems synchronous, you can do
synchronous I/O (O_SYNC) or you can use and check fsync/fdatasync results
which should give you pretty good coverage providing barriers are enabled.

It still won't catch a lot of cases because you sometimes see

- sectors being corrupted/dying that were not written by near to it
- writes that the drive thinks were successful and reports that way but
  turn out not to be readable

Alan
