Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZEEVo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZEEVo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZEEVor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:44:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38879 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758483AbZEEVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:44:47 -0400
Date: Tue, 5 May 2009 22:44:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090505224417.0f00c2f0@lxorguk.ukuu.org.uk>
In-Reply-To: <4A00ADDE.9000908@zytor.com>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the benefit of this?

I believe the "benefit" is that a certain posters proprietary
virtualisation product works better.

> I can see at least one immediate downside: some timeout values in the 
> kernel are still maintained in units of HZ (like poll, I believe), and 
> so with a lower HZ value we'll have higher roundoff errors.

And HZ=100 actually causes real problems for some video work (not in
Europe where its just peachy). We switched to 1000Hz a very long time ago
because it improved desktop feel and responsiveness. We switched to
tickless to keep that behaviour with good power and idle behaviour.

If we still have problems that give virtualisers hiccups then they will
be giving real processor power management the same grief so I don't think
meddling with HZ to harm the desktop is the right move - but if there are
improvements to tickless (eg timer granularity and bunching under
virtualisation) that would be far better to explore.

Alan
