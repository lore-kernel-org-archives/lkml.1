Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYKGDWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYKGDWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 22:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYKGDW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 22:22:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33389 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKGDW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:22:26 -0500
Date: Fri, 7 Nov 2008 12:21:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, Rik van Riel <riel@redhat.com>,
       fernando@oss.ntt.co.jp, Jeff Moyer <jmoyer@redhat.com>,
       menage@google.com, ngupta@google.com,
       Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
Subject: Re: [patch 3/4] io controller: Core IO controller implementation
 logic
Message-Id: <20081107122145.69500cd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081106153135.869625751@redhat.com>
References: <20081106153022.215696930@redhat.com>
	<20081106153135.869625751@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 10:30:25 -0500
vgoyal@redhat.com wrote:

> 
> o Core IO controller implementation
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 

2 comments after a quick look.

 - I don't recommend generic work queue. More stacked dependency between "work"
   is not good. (I think disk-driver uses "work" for their jobs.)

 - It seems this bio-cgroup can queue the bio to infinite. Then, a process can submit
   io unitl cause OOM.
   (IIUC, Dirty bit of the page is cleared at submitting I/O. 
    Then dirty_ratio can't help us.)
   please add "wait for congestion by sleeping" code in bio-cgroup.


Thanks,
-Kame

