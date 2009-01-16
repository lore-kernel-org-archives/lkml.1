Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZAPPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZAPPko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZAPPkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:40:31 -0500
Received: from sandeen.net ([209.173.210.139]:22120 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZAPPka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:40:30 -0500
Message-ID: <4970AA6D.2040604@sandeen.net>
Date: Fri, 16 Jan 2009 09:40:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
References: <496EB639.6090800@redhat.com> <20090115162031.a512232b.akpm@linux-foundation.org> <497003CC.8030503@redhat.com>            <4970060E.3080306@sandeen.net> <17214.1232120028@turing-police.cc.vt.edu>
In-Reply-To: <17214.1232120028@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 15 Jan 2009 21:59:10 CST, Eric Sandeen said:
> 
>> Oh, actually, I'd think not.  If the freeze was done properly by the
>> filesystem, all data was flushed, the fs was quiesced, and new IO was
>> blocked.  pdflush should never be visiting these...
> 
> Yes, but a lot of 'if's - and usually you're reaching for sysrq-S precisely
> *because* you suspect that stuff wasn't happening properly on its own...

Actually, only one if - if the fs implemented freeze properly.

Well, the use case I envision here is something like:

# freeze /my/mount/point/to/fs/to/snapshot

except oops, that wasn't mounted, and you just froze your root fs.

I was thinking more recovery from admin error, not programming error...

If we're using sysrq to work around any possible programming error, then
we have a pretty tough job to make sure that it always works, no?

-Eric
