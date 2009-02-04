Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZBDHOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZBDHOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 02:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZBDHOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 02:14:16 -0500
Received: from verein.lst.de ([213.95.11.210]:52745 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbZBDHOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 02:14:16 -0500
Date: Wed, 4 Feb 2009 08:13:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       oleg@redhat.com, viro@ZenIV.linux.org.uk, davidel@xmailserver.org,
       davem@davemloft.net, hch@lst.de, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Message-ID: <20090204071320.GA19348@lst.de>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com> <20090203140543.6e915f97.akpm@linux-foundation.org> <1233699722.3243.127.camel@calx> <20090203153740.363d0a04@bike.lwn.net> <20090203145346.8df40277.akpm@linux-foundation.org> <20090203161931.4054a25e@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203161931.4054a25e@bike.lwn.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 04:19:31PM -0700, Jonathan Corbet wrote:
>  1) Use i_lock to protect accesses to f_flags.  This would enable some 
>     BKL usage to be removed, but would not fix fasync.

What about just turning f_ep_lock into f_lock and using it?

>  2) Move responsibility for the FASYNC bit into ->fasync(), with
>     fasync_helper() doing it in almost all situations.  The remaining
>     BKL usage would then go away.
> 
>  3) The same optional fasync() return values cleanup.

These two sound like a good thing to do no matter what the final locking
looks like.  I think they should be moved to the front of the patch
series and queued up no matter what.

