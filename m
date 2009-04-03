Return-Path: <linux-kernel-owner+w=401wt.eu-S935147AbZDCWah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147AbZDCWah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZDCWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:30:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZDCWa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:30:27 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: Linux 2.6.29
References: <20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
	<20090401143622.b1885643.akpm@linux-foundation.org>
	<20090402010044.GA16092@elte.hu>
	<20090403040649.GF3795@csclub.uwaterloo.ca>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 03 Apr 2009 18:28:36 -0400
In-Reply-To: <20090403040649.GF3795@csclub.uwaterloo.ca> (Lennart Sorensen's
	message of "Fri, 3 Apr 2009 00:06:49 -0400")
Message-ID: <x49myaxjrsb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> On Thu, Apr 02, 2009 at 03:00:44AM +0200, Ingo Molnar wrote:
>> I'll test this (and the other suggestions) once i'm out of the merge 
>> window.
>> 
>> I probably wont test that though ;-)
>> 
>> Going back to v2.6.14 to do pre-mutex-merge performance tests was 
>> already quite a challenge on modern hardware.
>
> Well after a day of running my mythtv box with anticipatiry rather than
> the default cfq scheduler, it certainly looks a lot better.  I haven't
> seen any slowdowns, the disk activity light isn't on solidly (it just
> flashes every couple of seconds instead), and it doesn't even mind
> me lanuching bittornado on multiple torrents at the same time as two
> recordings are taking place and some commercial flagging is taking place.
> With cfq this would usually make the system unusable (and a Q6600 with
> 6GB ram should never be unresponsive in my opinion).
>
> So so far I would rank anticipatory at about 1000x better than cfq for
> my work load.  It sure acts a lot more like it used to back in 2.6.18
> times.

Hi, Lennart,

Could you try one more test, please?  Switch back to CFQ and set
/sys/block/sdX/queue/iosched/slice_idle to 0?

I'm not sure how the applications you are running write to disk, but if
they interleave I/O between processes, this could help.  I'm not too
confident that this will make a difference, though, since CFQ changed to
time-slice based instead of quantum based before 2.6.18.  Still, it
would be another data point if you have the time.

Thanks in advance!

-Jeff
