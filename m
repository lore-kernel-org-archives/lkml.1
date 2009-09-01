Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZIAJi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZIAJi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZIAJi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:38:58 -0400
Received: from cmpxchg.org ([85.214.51.133]:39509 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZIAJi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:38:57 -0400
Date: Tue, 1 Sep 2009 11:39:10 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [mmotm][BUG] free is bigger than presnet Re: mmotm 2009-08-27-16-51 uploaded
Message-ID: <20090901093910.GA24110@cmpxchg.org>
References: <200908272355.n7RNtghC019990@imap1.linux-foundation.org> <20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 06:00:32PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 27 Aug 2009 16:55:42 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-08-27-16-51 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.31-rc7:
> > 
> 
> I'm not digggin so much but /proc/meminfo corrupted.
> 
> [kamezawa@bluextal cgroup]$ cat /proc/meminfo
> MemTotal:       24421124 kB
> MemFree:        38314388 kB

The bug is that every anon deactivation increases the 'free pages'
counter.  This should fix it:

http://marc.info/?l=linux-kernel&m=125148840818965&w=2

	Hannes
