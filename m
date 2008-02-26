Return-Path: <linux-kernel-owner+w=401wt.eu-S1765792AbYBZVpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765792AbYBZVpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765593AbYBZVpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:45:01 -0500
Received: from twin.jikos.cz ([213.151.79.26]:37091 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765472AbYBZVo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:44:58 -0500
Date: Tue, 26 Feb 2008 22:44:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on
 thinkpad T61p
In-Reply-To: <20080226213200.GL17932@hjernemadsen.org>
Message-ID: <Pine.LNX.4.64.0802262242070.7699@twin.jikos.cz>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
 <20080225114611.d91791f6.akpm@linux-foundation.org> <20080226085403.GI17932@hjernemadsen.org>
 <20080226213200.GL17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Klaus S. Madsen wrote:

> The bad news, however, is that it segfaults reliably after "Calling
> get_mode" when I run it on 2.6.25-rc3. GDB shows that the segmentation
> fault happens in the libx86 library, but as the version I use doesn't
> have debug symbols, I don't have a complete backtrace. I'll try to
> compile a version of libx86 tomorrow evening with debug symbols, and
> return with a proper backtrace.

Hmm, just a random shot (shouldn't be the case, but just to be on the safe 
side) -- could you please try

        echo 0 > /proc/sys/kernel/randomize_va_space

to see whether it removes the segfault by any chance?

I don't know how exactly execution of real-mode code through libx86 works, 
but this might be worth trying before starting the next round of 
bisection.

Thanks,

-- 
Jiri Kosina
SUSE Labs

