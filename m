Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbXKBK64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbXKBK64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXKBK6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:58:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43334 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbXKBK6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:58:47 -0400
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200711011926.07641.flamingice@sourmilk.net>
References: <20071101191716.GA3201@pogo>
	 <200711011926.07641.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 11:58:40 +0100
Message-Id: <1194001120.27652.353.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 19:26 -0400, Michael Wu wrote:
> On Thursday 01 November 2007 15:17:16 Luis R. Rodriguez wrote:
> > mcgrof@pogo:~/devel/wireless-2.6$ git-describe
> > v2.6.24-rc1-146-g2280253
> >
> > So I hit segfault with lockdep on count_matching_names() on the
> > strcmp() multiple times now. This is reproducible and with different
> > wireless drivers.
> >
> I've found the problem. It appears to be in lockdep. struct lock_class has a 
> const char *name field which points to a statically allocated string that 
> comes from the code which uses the lock. If that code/string is in a module 
> and gets unloaded, the pointer in |name| is no longer valid. Next time this 
> field is dereferenced (count_matching_names, in this case), we crash.
> 
> The following patch fixes the issue but there's probably a better way.

Thanks, and indeed. From my understanding lockdep_free_key_range()
should destroy all classes of a module on module unload.

So I'm not quite sure what has gone wrong here..


