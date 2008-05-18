Return-Path: <linux-kernel-owner+w=401wt.eu-S1750716AbYERXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750716AbYERXIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 19:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYERXIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 19:08:47 -0400
Received: from ns1.codewiz.org ([89.97.188.34]:39431 "EHLO trinity.develer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYERXIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 19:08:46 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 May 2008 19:08:46 EDT
X-Spam-Virus: No
Cc: Bernie Innocenti <bernie@codewiz.org>, lkml <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net
Message-Id: <3A94CB82-6BF7-42DD-96DE-5B6018600077@develer.com>
From: Stefano Fedrigo <aleph@develer.com>
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20080518162429.GE31413@mit.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: ext3_dx_add_entry: Directory index full!
Date: Mon, 19 May 2008 01:01:57 +0200
References: <48304CE2.1090808@codewiz.org> <20080518162429.GE31413@mit.edu>
X-Mailer: Apple Mail (2.919.2)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 19 01:02:04 2008
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4830b56c36883742315553
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 18, 2008, at 6:24 PM, Theodore Tso wrote:

> No, not a bug, but a limit.  Ext3's hash directores are limited to a
> depth of 3 blocks, which normally isn't a problem if you are using a
> 4k blocksize, since each internal node is small; only 8 bytes.  So you
> have a fanout of 508 for each internal node, and two internal nodes
> gets you to over 250,000 4k directory blocks.  But with a 1k
> blocksize, the internal node fanout is only 124, so that only gets you
> a bit more than 15,000 1k directory blocks.

So, if I understand correctly, with a 1024 bytes blocksize, dir_index,  
and inode size of 128 byte, the maximum number of files in a directory  
is 123008.  With 4k blocks this limit rises to 8,258,048 files?
