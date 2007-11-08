Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbXKHS6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbXKHS6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761325AbXKHS6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:58:37 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:60035 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761114AbXKHS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:58:35 -0500
Message-ID: <47335C67.2070107@crispincowan.com>
Date: Thu, 08 Nov 2007 10:58:47 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Problem with accessing namespace_sem from LSM.
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp> <20071106133559.GA13366@infradead.org> <200711062352.CIJ34385.LSOHJFOVFFOtMQ@I-love.SAKURA.ne.jp> <20071107173039.GA25560@infradead.org> <200711080704.CHC65673.OOtFJFFSHQVOML@I-love.SAKURA.ne.jp> <20071107224523.GA8223@infradead.org>
In-Reply-To: <20071107224523.GA8223@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Nov 08, 2007 at 07:04:23AM +0900, Tetsuo Handa wrote:  
>> The reason why I want to access namespace_sem inside security_inode_create() is that
>> it doesn't receive "struct vfsmount" parameter.
>> If "struct vfsmount" *were* passed to security_inode_create(), 
>> I have no need to access namespace_sem.
>>     
> Same argument as with the AA folks: it does not have any business looking
> at the vfsmount.  If you create a file it can and in many setups will
> show up in multiple vfsmounts, so making decisions based on the particular
> one this creat happens through is wrong and actually dangerous.
>   
This has been said many times, and I have never been able to translate
it into anything other than "pathname access control is bad".

Pathname-based access control systems, among other things, let you write
a policy that says "you may create files under /foo/bar/baz". So when
you attempt to create a file "/foo/bar/baz/biff" the LSM needs to know
which VFS mount you are creating it in.

Multiple mount points, bind mounts, and other fun with mounting, do in
fact allow you to create aliases. Because of that, an LSM that set a
policy of "you can create files anywhere *except* /foo/bar/baz" would be
trivially bypassable. But a policy that says "You may *only* create
files under /foo/bar/baz" (plus whatever other explicit permissions it
grants) does not seem to create any problems, so long as the confined
processes are not permitted to create arbitrary aliases by using fun
with mount.

So just exactly what is dangerous about this?

Caveat: complaints that you can create a policy that is bypassable are
not interesting, you can do that with any policy system. To show
"dangerous" you would have to show how a reasonable policy that should
be secure is in fact bypassable. This threat from mount point aliases,
this has often been conjectured but has never been shown.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

