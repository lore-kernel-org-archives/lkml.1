Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbXL2Hz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbXL2Hz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 02:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXL2HzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 02:55:21 -0500
Received: from [194.117.236.238] ([194.117.236.238]:44432 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXL2HzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 02:55:20 -0500
Date: Sat, 29 Dec 2007 09:52:42 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Richard Harman <richard@richardharman.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071229095242.1300e19c@linux360.ro>
In-Reply-To: <47754735.1050009@richardharman.com>
References: <47754735.1050009@richardharman.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007 13:57:57 -0500
Richard Harman <richard@richardharman.com> wrote:

> I just saw this thread online from someone else who was having
> problems with an HP laptop -- I believe my laptop falls into this
> category.
> 
> The laptop is currently running Fedora Core 8, but I couldn't figure
> out what kernel that diff was against.  I'm not experienced with
> git.  Can you give me a few pointers on how to get that patch applied
> to a kernel tarball?  I'll be more than willing to be your test
> subject to see how well this patch and whatever future revision of it
> may work.
> 
> Richard

Hi,

I'll assume you didn't read the thread careful enough, so I have to
emphasize the fact that this patch won't improve power savings (even
more, it may actually consume an additional 1-2 Watts). Try it only if
you need dynticks for another purpose than just saving power (in which
case, you should wait until a better solution comes up, namely
LAPIC-less dynticks).

IIRC, the diff was made against 2.6.24-rc4, but it applies okay on the
latest -rc (2.6.24-rc6 as of now) as far as I can see. Copy starting
with the line below "---" all the way to the end and save it to a file
(make sure tabs don't get messed up), then apply with "patch -p1" as
you would apply any other patch. Run "make xconfig" (or whatever
interface to Kconfig you use), make sure "Processor type and
features -> Disable C1E on AMD systems to make dynticks work" is set,
along with all other relevant options, then build and the kernel as
usual.
