Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbXLRBfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbXLRBfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXLRBfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:35:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53942 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbXLRBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:35:10 -0500
Date: Tue, 18 Dec 2007 10:38:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: swapping in 2.6.24-rc5-git3
Message-Id: <20071218103813.0ee4f159.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071217131726.GA14091@ics.muni.cz>
References: <20071217131726.GA14091@ics.muni.cz>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 14:17:26 +0100
Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> Hello,
> 
> does /proc/sys/vm/swappiness still work as expected? 
> # /proc/sys/vm# cat swappiness 
> 0
> 
> but scp-ing 2GB file causes many processes are swapped out due to increase of
> the file cache size. Why? This is totally catastrophic behaviour on the desktop.
> 

Hmm, which version of the kernel do you compare with ?

Seems following patch is the newest one, which changes meaning of swappiness.
Now the swap happens even if swappiness=0, when the system memory usage is highly
unbalanced or when memory reclaim doesn't make progress.
=
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4106f83a9f86afc423557d0d92ebf4b3f36728c1
=

> Is there a way to avoid it except turning off the swap?
> 
Maybe...no.

(*) I'm now working on memory resource controller in -mm kernel. please see/try
    and comments if interested.


Thanks,
-Kame

