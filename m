Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXEWNYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXEWNYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXEWNYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:24:02 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:47559 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbXEWNYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:24:00 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [RFC PATCH] file as directory
Date: Wed, 23 May 2007 15:23:54 +0200
User-Agent: KMail/1.9.6
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk>
In-Reply-To: <20070523113925.GT4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231523.55306.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 23. Mai 2007, Al Viro wrote:
> Then I do not understand what this mechanism could be used for, other
> than an odd way to twist POSIX behaviour and see how much of the userland
> would survive that.
I have some similar considerations about how userspace should deal with that.

The behaviour of simply "cd file/" are not that robust, I fear ...


> Certainly not useful for your "look into tarball 
> as a tree", unless you seriously want to scan the entire damn fs for
> tarballs at mount time and set up a superblock for each.  And for per-file
> extended attributes/forks/whatever-you-call-that-abomination it also
> obviously doesn't help, since you lose them for directories.
Well, *use cases* I can see. I'd like to use that - for loop mounting, 
archives, possibly using symlinks to remote filesystems "symlink1 => 
ssh:user@ip" (although that's possible with FUSE anyway - but would be 
possibly within a .zip, too), ...


But I'm not sure how to do the presentation to userspace *right*.


How about some special node in eg. /proc (or a new filesystem)?
Eg.
   /fileAsDir/etc/passwd/owner ...
would work for all *files*. For directories we do not know whether we're still 
climbing the hierarchy or would like to see meta-data.

Some way like a ".this" entry is not the Right Way IMO ...
Well, I cannot imagine a real good way to tell where I'd like to stop 
following the "normal" filesystem and go into the "generated" hierarchy ...

   /fileAsDir/level-3/usr/local/bin/owner
is not nice.


Regards,

Phil
