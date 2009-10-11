Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbZJKWPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbZJKWPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZJKWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:15:30 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44616 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZJKWP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Lv+063yaNyfriUUv1ZmWrsdQXAPmz3lOtYYokclqLSrDYsNUErORAfYu6mkbgjAjoB
         NoSFfWdvlRbyE6sXwx+Fnex7W78IDuXq6nzKHIcK9JLgkkau3VK2mhBlZhN16WVSQFG9
         Lwp51RTnZcG0UGOVWnRJr/IqsAwBRPWpco5w4=
Date: Mon, 12 Oct 2009 00:14:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
Message-ID: <20091011221448.GA8146@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091011210809.GC5486@nowhere> <20091011214053.GD5486@nowhere> <200910112350.24870.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910112350.24870.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 11:50:24PM +0200, Arnd Bergmann wrote:
> On Sunday 11 October 2009, Frederic Weisbecker wrote:
> > Now I'm adding the ioctl() sites too:
> > 
> > git-grep "\.ioctl *=" | grep -P "^\S+\.c" | wc -l
> > 452
> > 
> > Hehe :)
> 
> Not all of them, fortunately.
> 
> There are various *_operations structures that have a .ioctl pointer.
> While there are a lot of struct file_operations with a locked .ioctl
> operation, stuff like block_device_operations does not hold the
> BKL in .ioctl but in .locked_ioctl.
> 
> 	Arnd <><


Oh right. Thanks for the tip.

