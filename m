Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbXEVUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbXEVUkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXEVUjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:39:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbXEVUjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:39:51 -0400
Message-ID: <46535503.4020702@redhat.com>
Date: Tue, 22 May 2007 15:39:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
References: <20070306164447.GC3661@duck.suse.cz> <4632710C.5030104@sandeen.net>
In-Reply-To: <4632710C.5030104@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

> Jan -
> 
> I ran 2.6.21 + your udf patches from -mm through some udf tests which,
> oddly enough, can be found in the xfstests test suite in xfsprogs cvs
> from sgi.
> 
> It looks much better than before, but I was able to trip some of your
> asserts.  They were generated while fsx was running.  The good news,
> though, is that fsx passed.  :)  I haven't looked into it much further
> yet, but wanted to let you know.

Here's a short hacky testcase that trips the assert around line 123 of
udf/truncate.c  I'm looking into it but you may immediately see what the
problem is...?


#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char ** argv)
{
        int fd;
        char buf[65536];

        fd = open("testfile", O_WRONLY|O_CREAT);
        lseek(fd, 16797, SEEK_SET);
        write(fd, buf, 22935);
        close(fd);

        fd = open("testfile", O_WRONLY);
        lseek(fd, 31281, SEEK_SET);
        write(fd, buf, 9592);
        close(fd);
}

-Eric
