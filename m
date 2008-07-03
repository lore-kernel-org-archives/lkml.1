Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYGCO6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYGCO6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYGCO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:58:36 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:42954 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYGCO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:58:35 -0400
Message-ID: <486CE247.5020904@linux.vnet.ibm.com>
Date: Thu, 03 Jul 2008 11:29:27 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Hunter Adrian <ext-Adrian.Hunter@nokia.com>
Subject: Re: Is VFS behavior fine?
References: <486B419F.7050407@nokia.com>
In-Reply-To: <486B419F.7050407@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> The result of it was that the '->delete_inode()' operation for
> the 'xxx' directory inode is not called. It is not called even
> after 'cd /'. However, if we do not do the 'touch tmp' command
> (which actually fails), '->delete_inode()' _is_ called for 'xxx'.
>
> So 'touch tmp' has a side effect. You may notice this by watching
> 'cat /proc/slabinfo | grep dentry' while running the following
> script:
I tried to reproduce this on my system using an EXT3 filesystem, leaving 
the script running the entire night. When I wake up I found that the 
system disk was full. So, besides the memory issue, this problem also 
consume some bytes on your filesystem.
