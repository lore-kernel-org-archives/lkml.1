Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZCZUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZCZUEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbZCZUDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:03:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54577 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322AbZCZUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:03:52 -0400
Date: Thu, 26 Mar 2009 20:02:58 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326200258.GA10313@srcf.ucam.org>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326185900.166a1097@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326185900.166a1097@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:59:00PM +0000, Alan Cox wrote:
> > And what's the argument for not doing it in the kernel?
> > 
> > The fact is, "atime" by default is just wrong.
> 
> It probably was a wrong default - twenty years ago. Actually it may well
> have been a wrong default in Unix v6 8)
> 
> However
> - atime behaviour is SuS required

SuS says "An implementation may update fields that are marked for update 
immediately, or it may update such fields periodically. At an update 
point in time, any marked fields shall be set to the current time and 
the update marks shall be cleared" but doesn't appear to specify any 
kind of time limit. A conforming implementation could wait a century 
before performing the update. So while relatime doesn't conform, the 
practical difference is meaningless. You can't depend on atime being 
updated in a timely manner.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
