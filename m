Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXJCO0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXJCO0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXJCO0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:26:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47645 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbXJCO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:26:07 -0400
Date: Wed, 3 Oct 2007 15:26:01 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003142600.GJ8181@ftp.linux.org.uk>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <20071003133422.GI8181@ftp.linux.org.uk> <20071003140842.GA8837@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003140842.GA8837@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 04:08:42PM +0200, Ingo Molnar wrote:
> > Charming...  So we get d_path() either returning junk or we get 
> > something that isn't NUL-terminated.  Which one it is?  I.e. what does 
> > p look like and what's in s?
> 
> could be use-after-free as well, as CONFIG_PAGEALLOC was enabled.

Umm...  d_path() had just written there, so use-after-free is not too
likely to trigger page fault on read immediately afterwards - you'd
need a pretty tight race to hit it.
