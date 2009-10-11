Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZJKVIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZJKVIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZJKVIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:08:51 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:33506 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZJKVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pKcFcffdah3uDbXUMU9P/C7/s0/+fGS9/g+LvJInfSoXMDAdKxhZF73uzYztYYPMSh
         h2j1ouJDCPmyg2it2Rn6Apjy6Aafm80PASSnC6HhhYHmLNmberWz7ncnxQ1L6JrHXiNo
         9j521g3sclKM/vgdE4Q0jkZyGlMOlkKQaAq08=
Date: Sun, 11 Oct 2009 23:08:10 +0200
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
Message-ID: <20091011210809.GC5486@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091010153349.499835683@linutronix.de> <200910112131.40608.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910112131.40608.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 09:31:40PM +0200, Arnd Bergmann wrote:
> On Saturday 10 October 2009, Thomas Gleixner wrote:
> > There is nothing to protect inside nvram_llseek(), the file
> > offset doesn't need to be protected and nvram_len is only
> > initialized from an __init path.
> > 
> > It's safe to remove the big kernel lock there.
> > 
> 
> The generic_nvram driver still uses ->ioctl instead of ->unlocked_ioctl.
> I guess it would be helpful to change that in the same series, so we
> don't get the BKL back as soon as someone does a pushdown into the
> remaining ioctl functions.
> 
> 	Arnd <><


Right!
I'll add that in a second patch.

I've completely forgotten this ioctl/unlocked_ioctl thing.

