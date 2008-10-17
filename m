Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYJQQyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYJQQyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYJQQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:54:39 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:12753 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbYJQQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kQGsT8+Gh34JGRc2dNXKKCjP6BNlnYLWeJRmEwuTf7gHg0az7I3y7orCrUUIFEu9bo
         CRiowa6/5F2/TeMUFG+2MVLnkTipQAp5l6LETN+LDKJun0ZaYweohcqyxvG8t0p7Fyek
         gP1SDnzVrRFrxEkCYHYQbOOrzJvvXG4+eHj98=
Message-ID: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
Date: Fri, 17 Oct 2008 20:54:35 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081017164116.GA17375@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/17 Christoph Hellwig <hch@infradead.org>:
> On Fri, Oct 17, 2008 at 04:43:07PM +0400, Alexander Beregalov wrote:
>> It is SMP x86_64, rootfs is on XFS
>
> The message comes from code in XFS, but I really wonder where the atomic
> context comes from.  xfs_iget_core has a few changes in the tree pulled
> into todays Linux-next, but it's still missing the recent updates
> redoing this area completely.  In some ways it looks like this process
> has the the atomic context flag left pending somewhere, but that should
> also trigger warnings on the VFS locks like i_mutex.
>
> Very misterious.
>
> IS there a specific workload you can reproduce this with?
>
Workload is not specific, many i/o commands trigger the message.

 dmesg|grep comm:
[    4.419605] Pid: 1396, comm: mkdir Not tainted 2.6.27-next-20081017 #2
[    6.056443] Pid: 1782, comm: dhcpcd Not tainted 2.6.27-next-20081017 #2
[   17.899905] Pid: 1791, comm: dhcpcd-run-hook Not tainted
2.6.27-next-20081017 #2
[ 3846.588549] Pid: 2005, comm: screen Not tainted 2.6.27-next-20081017 #2
[ 4416.242723] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4430.618037] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4431.641578] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4432.944265] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
[ 4590.330706] Pid: 2026, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[14882.802479] Pid: 2058, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[16955.026436] Pid: 2091, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[18466.645935] Pid: 2119, comm: git-merge Not tainted 2.6.27-next-20081017 #2
[19165.813049] Pid: 2150, comm: git-merge Not tainted 2.6.27-next-20081017 #2
