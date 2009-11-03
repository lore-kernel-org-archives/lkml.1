Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZKCWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZKCWSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZKCWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:18:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59301 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZKCWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:18:52 -0500
To: Benjamin LaHaise <bcrl@lhnet.ca>
Cc: Greg KH <greg@kroah.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs directory scaling: rbtree for dirent name lookups
References: <20091101163130.GA7911@kvack.org>
	<20091103035058.GA19515@kroah.com> <20091103200155.GQ8227@kvack.org>
	<m1my338fbi.fsf@fess.ebiederm.org> <20091103215251.GS8227@kvack.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 14:18:53 -0800
In-Reply-To: <20091103215251.GS8227@kvack.org> (Benjamin LaHaise's message of "Tue\, 3 Nov 2009 16\:52\:51 -0500")
Message-ID: <m1zl735k1e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@lhnet.ca> writes:

> On Tue, Nov 03, 2009 at 01:32:33PM -0800, Eric W. Biederman wrote:
>> Are your numbers from your application and are they real world?
>> In which case they are interesting, but it would be good if
>> we could also have microbenchmark numbers that just measure
>> the sysfs costs.   If nothing else I am seeing a big startup
>> overhead that isn't being subtracted out that makes it hard
>> to see the real costs here.
>
> They're application based, so there's a bunch of other overhead included 
> that won't show up on a microbenchmark.  Each interface requires a round 
> trip between 2 L2TP daemons, so there are lots of syscalls and other cache 
> polluting effects that won't show up on a microbenchmark.  One of the L2TP 
> daemons is configured not to instantiate any kernel state -- running in 
> this mode, it has very little overhead.
>
> The other thing to note is that the costs posted are how long it takes to 
> add an additional 5,000 interfaces in the given range, not the total time 
> to add say 35,000 interfaces (I didn't feel like waiting that long).

Ok.  That makes a lot more sense.  The times you posted ideally would be flat
but they go up from 12s to 60s.

Eric
