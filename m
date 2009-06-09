Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZFIAEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZFIAEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZFIAEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:04:41 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35720 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZFIAEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:04:40 -0400
Date: Mon, 8 Jun 2009 17:04:37 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13116] Can't boot with nosmp
Message-ID: <20090608170437.1c2386a5@nehalam>
In-Reply-To: <e9c3a7c20906080929l1a4ec739t7585f6bba54bf684@mail.gmail.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	<D9VoutSOyXP.A.xm.Vb7KKB@chimera>
	<20090608091544.53a94235@nehalam>
	<e9c3a7c20906080929l1a4ec739t7585f6bba54bf684@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did some more debugging, and the problem appears to be that
booting with nosmp still leaves all the CPU's present in the cpu
possible mask. So code like dma engine (or loopback device), that
use alloc_percpu get broken.

Not sure why all the cpu's are still showing up in the possible mask.
Rusty? do you have an answer.
