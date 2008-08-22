Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYHVKAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYHVKAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYHVKAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:00:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYHVKAb convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:00:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Date: Fri, 22 Aug 2008 12:00:25 +0200
User-Agent: KMail/1.9.9
Cc: jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?windows-1252?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de> <48AE22F5.3000309@lougher.demon.co.uk>
In-Reply-To: <48AE22F5.3000309@lougher.demon.co.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808221200.26052.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cphhKMWdBDw1X65BOlD3TU6mf3NQpCOfByQQ
 WvqtPR7dOOqGwf/Zv0BgdBIUzSYeW21IVaAEXk/D1l35IfjbyJ
 fu4MYSy5Ak10LHfAPv6YQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008, Phillip Lougher wrote:
> > 
> > This looks very nice, but could use some comments about how the data is
> > actually stored on disk. It took me some time to figure out that it actually
> > allows to do tail merging into compressed blocks, which I was about to suggest
> > you implement ;-). Cramfs doesn't have them, and I found that they are the
> > main reason why squashfs compresses better than cramfs, besides the default
> > block size, which you can change on either one.
> 
> Squashfs has much larger block sizes than cramfs (last time I looked it 
> was limited to 4K blocks), and it compresses the metadata which helps to 
> get better compression.  But tail merging (fragments in Squashfs 
> terminology) is obviously a major reason why Squashfs gets good compression.

The *default* block size in cramfs is smaller than in squashfs, but they both
have user selectable block sizes. I found the impact of compressed metadata
to be almost zero. I hacked up a mksquashfs to avoid tail merging, and found
that the image size for squashfs and cramfs is practically identical if you
use the same block size and no tail merging.

> The AXFS code is rather obscure but it doesn't look to me that it does 
> tail merging.  The following code wouldn't work if the block in question 
> was a tail contained in a larger block.  It assumes the block extends to 
> the end of the compressed block (cblk_size - cnode_offset).

yes, I thought the same thing when I first read that code, and was about
to send a lengthy reply about how it should be changed when I saw that
it already does exactly that ;-).

	Arnd <><
