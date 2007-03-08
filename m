Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbXCHSGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbXCHSGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXCHSGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:06:43 -0500
Received: from terminus.zytor.com ([192.83.249.54]:60038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXCHSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:06:43 -0500
Message-ID: <45F05040.4090602@zytor.com>
Date: Thu, 08 Mar 2007 10:04:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org> <45F0426C.8000009@zytor.com> <20070308175729.GA7054@kryten>
In-Reply-To: <20070308175729.GA7054@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
>> By the way, it's a massive snafu that the swap area magic number is 
>> dependent on PAGE_SIZE.  There is absolutely no good reason for that.
> 
> Agreed, its been a big problem booting between 4kB and 64kB kernels on
> ppc64.

The easiest way to fix this would be to always park the swap magic at 
the offset of the smallest page size in use, which is 4K.  This is 
analogous how the offset for the ext2/3 superblock got fixed at 1K -- 
for 1K blocks, it's the second block, but for larger blocks, it's part 
of the first block.  If we fix the offset of the swap magic at 4096 
minus the offset that's already there, it will always fall in the first 
page regardless of page size.

	-hpa
