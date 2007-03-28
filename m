Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXC1Gp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXC1Gp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXC1Gp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:45:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:41176 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXC1GpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mnhOqCn1iFBPZCUf5lopNFbchkyLUYmkRtuq02cxfzWpjmWOqVa69vFmDY3x70X+HhqQe3Rj+2Hp3dx8UUn+qFtPitY6PGVyyZG6dAvgloadDB2BChEScvUnkzFixtgbS74XOL1PDSe1oq3B5L7zLAlTmpuolxtareRgbnqLoMI=
Message-ID: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
Date: Wed, 28 Mar 2007 02:45:23 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Xin Zhao" <uszhaoxin@gmail.com>
Subject: Linux page cache issue?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If a Linux process opens and reads a file A, then it closes the file.
Will Linux keep the file A's data in cache for a while in case another
process opens and reads the same in a short time? I think that is what
I heard before.

But after I digged into the kernel code, I am confused.

When a process closes the file A, iput() will be called, which in turn
calls the follows two functions:
iput_final()->generic_drop_inode()

But from the following calling chain, we can see that file close will
eventually lead to evict and free all cached pages. Actually in
truncate_complete_page(), the pages will be freed.  This seems to
imply that Linux has to re-read the same data from disk even if
another process B read the same file right after process A closes the
file. That does not make sense to me.

/***calling chain ***/
generic_delete_inode/generic_forget_inode()->
truncate_inode_pages()->truncate_inode_pages_range()->
truncate_complete_page()->remove_from_page_cache()->
__remove_from_page_cache()->radix_tree_delete()

Am I missing something? Can someone please provide some advise?

Thanks a lot
-x
