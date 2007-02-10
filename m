Return-Path: <linux-kernel-owner+w=401wt.eu-S1751338AbXBJNfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbXBJNfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 08:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXBJNfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 08:35:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55198 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbXBJNfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 08:35:40 -0500
Date: Sat, 10 Feb 2007 13:48:53 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070210134853.5ab6c211@localhost.localdomain>
In-Reply-To: <p73ps8igo0v.fsf@bingen.suse.de>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<20070209193753.76bc2430@localhost.localdomain>
	<p73ps8igo0v.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well it's a technical issue -- it conflicts with the machine check
> code that is already implemented by stealing away its events.
> You would first need a CONFIG_MCE=n on x86-64 at least, otherwise
> one of them will be unhappy.

That is a fair point, albeit after far too long sitting stuck in the tree.
I'll have a look into this a bit further, probably MCE_K8 should feed off
the output of the MCE driver.

> The other issue is that the existing code does everything EDAC
> K8 does already perfectly fine, just in a small fraction of 
> the code.

Which is false. It provided a totally inconsistent interface to user
space, while the EDAC layer provides the consistency many people need and
want. Also unless it has changed remarkably the MCE driver doesn't do
scrubbing which is needed in software on some chip revisions.

The MCE driver is small, neat, incomplete for some cases and different
to all the other platforms as they use off CPU memory controllers. Its
ideal for a lot of uses but not big enterprise systems. Thats why we need
both.

Alan
