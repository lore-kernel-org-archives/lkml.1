Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420Ab0ANFqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0ANFqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0ANFqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:46:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51748 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0ANFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:46:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 14 Jan 2010 14:42:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/8] vfs: fix too big f_pos handling
Message-Id: <20100114144250.ebbe6601.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100114051308.GA14616@ZenIV.linux.org.uk>
References: <20100113140955.GA18593@localhost>
	<20100114051308.GA14616@ZenIV.linux.org.uk>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 05:13:08 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Jan 13, 2010 at 10:09:56PM +0800, Wu, Fengguang wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, rw_verify_area() checsk f_pos is negative or not. And if
> > negative, returns -EINVAL.
> > 
> > But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..
> > has negative offsets. And we can't do any access via read/write
> > to the file(device).
> > 
> > This patch introduce a flag S_VERYBIG and allow negative file
> > offsets.
> 
> Ehh...  FMODE_NEG_OFFSET in file->f_mode, perhaps?
> 
Any method is okay for me.
I was just not sure where I could modify without problem.
If modifing f_mode is allowed, I'll write new version.

Thank you for advice. 

I'm sorry that I don't have enough time this week. So, I'll try next week.
I think dropping this patch itself has no big influence to this patch set. 
(but debug will be harder ;)
Thanks,
-Kame

