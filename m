Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZAFHtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZAFHtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZAFHtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:49:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZAFHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hq1E0jfSss7XRkJ7+s05ciq0/8yfcZJPZrmdZiNkc9gCU8XQJk3UA4adnbHm+bRLgW
         5jcDp0KHgXVWxRTs58O/t+fBZfHTi8o7HRuUxRNMZwPLyea/NB7FcVB1o6B1q5/LJ/yF
         MWsaz9zSq/suC2YmWve4lqm4ya9K6YMeMEywE=
Date: Tue, 6 Jan 2009 10:49:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       riel@redhat.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
Message-ID: <20090106074928.GA7671@localhost>
References: <20090105103132.GD7645@localhost> <20090105163742.08777d73.akpm@linux-foundation.org> <20090106145741.e9844b93.kamezawa.hiroyu@jp.fujitsu.com> <20090106153036.1263b5ab.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106153036.1263b5ab.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KAMEZAWA Hiroyuki - Tue, Jan 06, 2009 at 03:30:36PM +0900]
| On Tue, 6 Jan 2009 14:57:41 +0900
| KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
| 
| > On Mon, 5 Jan 2009 16:37:42 -0800
| > Andrew Morton <akpm@linux-foundation.org> wrote:
| > 
| > > On Mon, 5 Jan 2009 13:31:32 +0300
| > > Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > > 
| > > > __nr_to_section should check for array bound overflow.
| > > > We should better get NULL dereference then silently
| > > > pass some memory snippet out of bounds to a caller.
| > > > 
| > > 
| > > Are there actually any known problems here?
| > > 
| > 
| > IIRC, I never saw any problem. (But I may see in memory-hotplug development.)
| 
| I digged mails and seems this patch is from this thread.
| 
| =
| http://lkml.org/lkml/2009/1/4/61
| =
| 
| He seems to want to hunt boot time failure.
| (Finally, BIOS-update was necessary for original problem of this thread.)
| 
| Cyrill, could you modify this WARN_ON() works works when __nr_to_section()
| is called directly by sparse.c and memhotplug.c ?
| 
| Adding WARN_ON() in pfn_to_page() is overkill.
| 
| Thanks,
| -Kame
| 

Thanks for review Kame, this patch should be just dropped.

Actually the only code snippet which make me nervious is
sizeof (mem_section) part. Which is to remain power of
two and even doesn't have 'packed' attribute neither any
comments above. And if it happens that it will be modified
or say gcc decide to add some bytes here (bugs happens) we
would silently address wrong mem_section. So I think at least
the 'comment' part of my patch is deserve to be applied :)

		- Cyrill -
