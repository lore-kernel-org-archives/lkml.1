Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZJ0WT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZJ0WT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZJ0WT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:19:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45691 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534AbZJ0WT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:19:28 -0400
Date: Tue, 27 Oct 2009 22:21:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Gregory Haskins" <ghaskins@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Zillions of warnings in -next
Message-ID: <20091027222112.74058162@lxorguk.ukuu.org.uk>
In-Reply-To: <4AE7258D0200005A000576F6@sinclair.provo.novell.com>
References: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
	<4AE7258D0200005A000576F6@sinclair.provo.novell.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just did a 32-bit build and indeed reproduced the warnings.  However, the warnings
> appear to be dubious as the code is properly (afaict) annotated with explicit casts, and
> I believe they are doing what I intended.
> 
> Basically I have structures that are always 64 bit (so we can have a mixed-mode 32-bit
> guest talk to a 64-bit hypervisor, for instance).  Therefore I am casting between native
> and u64, but the compiler doesn't like this.  Does anyone have any suggestions on ways
> to fix this so the compiler is happy?

	foo = (void *)(unsigned long)x

works for the general case because Linux assumes ptr fits ulong

Similarly in the other direction.

Alan
