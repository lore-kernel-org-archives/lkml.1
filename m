Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZHYSE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZHYSE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZHYSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:04:56 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:57795
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755594AbZHYSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:04:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Ysz1hjXqwwP5GRNfJi4SwpDQ/YEA9Z9s+H52PDoWdnOdaiiMx7B5Y5muHJz2PFpC;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4A9427C7.8020009@earthlink.net>
Date: Tue, 25 Aug 2009 11:04:55 -0700
From: Jeff Shanab <jshanab@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090714 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early 	research
 Re: Starting a grad project that may change kernel VFS. Early 	research
References: <4A93428A.4070903@earthlink.net> <4A941F56.8060502@redhat.com>
In-Reply-To: <4A941F56.8060502@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 41b7b48e67ad7886d780f4a490ca6956abb457f1b4332f5249935be06fffbba42380a43fbc2326de350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 75.150.3.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Jeff Shanab wrote:
>
>> Updates start at the file and only work upwards back to root. How does
>> the hardlink get traversed?
>
> A hard link is just a second directory entry linking to
> the same inode.  There are no back links from inodes to
> the directory entries that point to them and they are
> essentially indistinguishable from files that are not
> hardlinked.
>
> Hard links have been done like this in pretty much every
> Unix filesystem since the 1970's.
>
Right :-( I need a workaround but I am not sure how the sementics should be.

In my example where we have a directory structure like so, where file is
the same.

test/foo/bar/file
test/bar/foo/file

My example would result in the size showing up in each directory at the
bar/file and foo/file level
Then the two numbers are passed up to test and the test directory size
would be wrong.
There is no real way to handle this becasue the two files look the same
to the filesystem.

I can even remove the initial file without effecting the other. Is there
a refcount I can take advantage of in the inode?

Even then, I can't decide what the semantic is.

For example I could add a pie chart that changed with navigation into my
gui file manager. This system would make that practical.
How would I display this information usefully to the user. I suppose if
they navigate into either subdir they see the file size, but somehow
when they navigate up to the directory that holds subdirs that
indirectly contain both of them, only 1 can be counted.  The problem is
that the top level directory will not be able to see the inodes of the
individual files, it is lost in the aggregate.

Still thinking....



