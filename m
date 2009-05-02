Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZEBJqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZEBJqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZEBJpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:45:50 -0400
Received: from mail.samba.org ([66.70.73.150]:53556 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZEBJpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:45:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.3862.34000.615391@samba.org>
Date: Sat, 2 May 2009 19:15:02 +1000
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <20090502015927.GJ8822@parisc-linux.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
	<20090501210109.GA3079@infradead.org>
	<20090502013729.GI6996@linux.vnet.ibm.com>
	<20090502015927.GJ8822@parisc-linux.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

 > So what's the purely technical argument for including this patch?

There is no purely technical argument for including this patch, as the
patch removes functionality without removing much code.

However, if you are willing to concede that there are good
non-technical arguments for wanting to "get the VFAT out" then
choosing the best way to achieve that is most definately a technical
decision, and that is what we can discuss here. 

Unfortunately I am unable to discuss any of the non-technical reasons
for why "get the VFAT out" might be a good idea in the first
place. That is damn frustrating, but it is just how things are.

So, on the technical front, what we need is a patch that keeps as much
functionality in Linux as possible while also giving us a high degree
of confidence that the patch will make the non-technical issues go
away.

This patch is one way to achieve that. There are certainly other
patches that would be possible, each with a different trade off in
terms of functionality loss. 

So, from a technical point of view the patch is pretty simple. When
the option is enabled you can still read all VFAT filesystems, with
any filenames (long or short). If you try to create a file with a long
filename then you get -1/ENAMETOOLONG. That means that Linux users
running a kernel with this patch enabled can plug in VFAT formatted
USB keys which have been written on windows/macosx etc systems, and
see all the files. When the Linux user wants to give a file to a
person running Windows, and they want to use a FAT based filesystem to
do it, then the Linux user has to choose a 8.3 name for the file. That
is a nuisance, but is a lot better than nothing.

Cheers, Tridge
