Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZAMTho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZAMTho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZAMThb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:37:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbZAMTha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:37:30 -0500
Date: Tue, 13 Jan 2009 11:37:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: handygewinnspiel@gmx.de
Cc: rjw@sisk.pl, HWerner4@gmx.de, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-Id: <20090113113700.776a94b5.akpm@linux-foundation.org>
In-Reply-To: <20090113191757.74290@gmx.net>
References: <20090112190420.51f75853@pedra.chehab.org>
	<20090112132130.6c932b85.akpm@linux-foundation.org>
	<20090112220624.4fbfee34@pedra.chehab.org>
	<20090112162337.318dd61d.akpm@linux-foundation.org>
	<20090113184755.87720@gmx.net>
	<20090113105947.9e774b69.akpm@linux-foundation.org>
	<20090113191757.74290@gmx.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 20:17:57 +0100 handygewinnspiel@gmx.de wrote:

> > 
> > It's the first such report I've seen.
> > 
> > Could you please generate the strace output for the failing command so
> > we can see which syscall is failing?
> 
> Attached two strace logs, one for the failed version, one for the working version.
> 

I'd have expected to see stat() returning -EOVERFLOW, but it isn't there.

googling around a bit seems to indcate that this might be a glibc issue:

http://sourceware.org/bugzilla/show_bug.cgi?id=1864
http://bugs.gentoo.org/show_bug.cgi?id=146951

But the traces are all using stat64() and fstat64().  And why would it
just start occurring now?

