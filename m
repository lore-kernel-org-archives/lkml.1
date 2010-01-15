Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab0AOTp6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087Ab0AOTp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080Ab0AOTp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:45:57 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Zhang\, Yanmin" <yanmin_zhang@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jens.axboe\@oracle.com" <jens.axboe@oracle.com>,
        "Zhang\, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as  close
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	<20091228084659.GA31389@sli10-desk.sh.intel.com>
	<4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	<20091228092844.GA9710@sli10-desk.sh.intel.com>
	<x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
	<x49hbqy3s3m.fsf@segfault.boston.devel.redhat.com>
	<1263187209.29897.33.camel@localhost>
	<4e5e476b1001110705y6c3319ducf6a15c2a2be5670@mail.gmail.com>
	<1263264218.29897.41.camel@localhost>
	<4e5e476b1001151132l406054f6xcc47b94e817d3af0@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 15 Jan 2010 14:45:50 -0500
In-Reply-To: <4e5e476b1001151132l406054f6xcc47b94e817d3af0@mail.gmail.com>
	(Corrado Zoccolo's message of "Fri, 15 Jan 2010 20:32:10 +0100")
Message-ID: <x494omnp2xd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> I think this patch has the same flaw as Shaohua's.
> The seekiness check that you introduce in cfq_rq_close is already
> present in its caller, cfq_close_cooperator, so it is not effective.

I don't think so.  There are two queues, here.  One queue is checked by
the caller, and that is the cur_cfqq.  The __cfqq needs to also be
checked.

> Up to now, the only patch that improves this situation is the one that
> changes the unmerge policy to unmerge after a single time slice.

Yes, I definitely agree with that, and I think that patch should go in.

Cheers,
Jeff
