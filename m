Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYIEQEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYIEQEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYIEQD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:03:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbYIEQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:03:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Cgezo+cMug6KwiMk82V7/QD7wV+vwLa+0rYEHfhL3GiW5jZm1EIUGxFwlR00gJlTW
	KhScwdIRg94LCVh6wr8hA==
Message-ID: <6599ad830809050903s7e1a1004i6b31660502c0dcf2@mail.gmail.com>
Date: Fri, 5 Sep 2008 09:03:49 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH][mmotm]memcg: handle null dereference of mm->owner
Cc: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Hugh Dickins" <hugh@veritas.com>, "Li Zefan" <lizf@cn.fujitsu.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080905174021.9fa29b01.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080905165017.b2715fe4.nishimura@mxp.nes.nec.co.jp>
	 <20080905174021.9fa29b01.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 1:40 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> BTW, I have a question to Balbir and Paul. (I'm sorry I missed the discussion.)
> Recently I wonder why we need MM_OWNER.
>
> - What's bad with thread's cgroup ?

Because lots of mm operations take place in a context where we don't
have a thread pointer, and hence no cgroup.

> - Why we can't disallow per-thread cgroup under memcg ?)

We can, but that's orthogonal - we still need to be able to get to
some thread (or a pointer directly in the mm to the cgroup, but with
multiple cgroup subsystems popping up that needed such a pointer, it
seems cleaner to have the owner pointer rather than adding multiple
separate cgroup subsystem pointers to mm.

Paul
