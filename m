Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXCRUNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXCRUNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXCRUNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:13:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54535 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXCRUNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:13:07 -0400
Date: Sun, 18 Mar 2007 14:13:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: forced umount?
Message-ID: <20070318201305.GA25355@parisc-linux.org>
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com> <1174245379.3538.252.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174245379.3538.252.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 08:16:19PM +0100, Arjan van de Ven wrote:
> the problem with the people who say they want forced umount is.. that
> most of the time they either want
> 1) get rid of the namespace entry
> or
> 2) want to stop any and all IO to a certain device/partition 

There is a third component - they want to deliver a fatal signal to
all processes which are waiting on IO to that sb.  My scenario here is a
machine with an NFS mount of a server which has gone down.  Cronjobs which
scan the whole filesystem (eg updatedb) soon pile up sleeping on access.
Equally, if one has one's ogg collection stored on said NFS server, the
ogg player will be in uninterruptible sleep while holding the sound device
open, preventing other applications from making sounds.  It's desirable
to be able to kill these apps dead, and the usual suggestion of 'mount
it soft,intr' isn't the greatest idea (and somewhat hard to change after
the fact).

I remember Linus suggesting a sleeping state between UNINTERRUPTIBLE and
INTERRUPTIBLE which would be FATAL_SIGNALS_ONLY.  The usual problem (of
short reads) isn't a problem if the task is only going to die when it
receives them.  Has anyone investigated this in any detail?  Perhaps
I'll take a look at doing it next week.
