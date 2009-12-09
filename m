Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZLIX7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZLIX7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbZLIX7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:59:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbZLIX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:59:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 08:56:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, kosaki.motohiro@jp.fujitsu.com,
       hugh.dickins@tiscali.co.uk, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, npiggin@suse.de,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
Message-Id: <20091210085634.255b244c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com>
References: <200912081016.198135742@firstfloor.org>
	<20091208211639.8499FB151F@basil.firstfloor.org>
	<6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 12:47:27 -0800
Paul Menage <menage@google.com> wrote:

> On Tue, Dec 8, 2009 at 1:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > The hwpoison test suite need to inject hwpoison to a collection of
> > selected task pages, and must not touch pages not owned by them and
> > thus kill important system processes such as init. (But it's OK to
> > mis-hwpoison free/unowned pages as well as shared clean pages.
> > Mis-hwpoison of shared dirty pages will kill all tasks, so the test
> > suite will target all or non of such tasks in the first place.)
> 
> While the functionality sounds useful, the interface (passing an inode
> number) feels a bit ugly to me. Also, if that group is deleted and a
> new cgroup created, you could end up reusing the inode number.
> 
I agree.

> How about an approach where you write either the cgroup path (relative
> to the memcg mount) or an fd open on the desired cgroup? Then you
> could store a (counted) css reference rather than an inode number,
> which would make the filter function cleaner too, since it would just
> need to compare css objects.
> 
Sounds reasonable.

Thanks,
-Kame


