Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbXGZKVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbXGZKVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbXGZKUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:20:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXGZKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:20:53 -0400
Date: Thu, 26 Jul 2007 11:20:25 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
Message-ID: <20070726102025.GJ27237@ftp.linux.org.uk>
References: <46A57068.3070701@yahoo.com.au> <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com> <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <p73abtkrz37.fsf@bingen.suse.de> <46A85D95.509@kingswood-consulting.co.uk> <20070726092025.GA9157@elte.hu> <20070726023401.f6a2fbdf.akpm@linux-foundation.org> <20070726094024.GA15583@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726094024.GA15583@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:40:24AM +0200, Ingo Molnar wrote:
> below is an updatedb hack that sets vfs_cache_pressure down to 0 during 
> an updatedb run. Could someone who is affected by the 'morning after' 
> problem give it a try? If this works then we can think about any other 
> measures ...

BTW, I really wonder how much pain could be avoided if updatedb recorded
mtime of directories and checked it.  I.e. instead of just doing blind
find(1), walk the stored directory tree comparing timestamps with those
in filesystem.  If directory mtime has not changed, don't bother rereading
it and just go for (stored) subdirectories.  If it has changed - reread the
sucker.  If we have a match for stored subdirectory of changed directory,
check inumber; if it doesn't match, consider the entire subtree as new
one.  AFAICS, that could eliminate quite a bit of IO...
