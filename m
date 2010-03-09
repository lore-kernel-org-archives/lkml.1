Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0CIRQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:16:52 -0500
Received: from lo.gmane.org ([80.91.229.12]:58006 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0CIRQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:16:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: opendir() on a file???
Date: Tue, 9 Mar 2010 16:05:47 +0100
Message-ID: <20100309160547.60641bc5@schatten.dmk.lab>
References: <1268126817.10479.643.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: f053212233.adsl.alicedsl.de
In-Reply-To: <1268126817.10479.643.camel@localhost>
X-Newsreader: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Mar 2010 04:26:57 -0500
Jon Masters <jonathan@jonmasters.org> wrote:

> Folks,
> 
> Now I might be missing something, and I know I'm behind on LKML[0], but
> the following isn't supposed to work in my book:
> 
> /*
>  * Weird kernel test
>  */
> 
> #include <sys/types.h>
> #include <dirent.h>
> #include <stdio.h>
> 
> int main(int argc, char **argv)
> {
>         DIR *dir;
> 
>         dir = opendir("foo.conf");
> 
>         if (dir)
>                 printf("WTF?\n");
> 
>         return 0;
> }
> 
> This is on an ext4 filesystem, whereas on a box with an older kernel
> this test correctly does not print "WTF?". I know some filesystems
> experiment with streams and treating files as directories, etc. but I
> wasn't aware that anything particular had changed recently?
> 
> The box is running almost an upstream kernel, and I can poke if I'm told
> this not intended: 2.6.34-0.8.rc0.git11.fc14.x86_64.
> 
> What am I missing?
> 
> Jon.
> 
> [0] The podcast isn't dead, I'm just suffering from a cold and will be
> taking a day off to recover and catch up with that sometime today.
> 
> 

perhaps you are missing this patch: 
commit 781b16775ba0bb55fac0e1757bf0bd87c8879632
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sat Mar 6 18:41:07 2010 +0000

    Fix a dumb typo - use of & instead of &&
    
    We managed to lose O_DIRECTORY testing due to a stupid typo in commit
    1f36f774b2 ("Switch !O_CREAT case to use of do_last()")
    
    Reported-by: Walter Sheets <w41ter@gmail.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


but this is only a guess...

cheers,
Flo


