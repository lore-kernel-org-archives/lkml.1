Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbXJ2TqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbXJ2TqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXJ2TmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:42:04 -0400
Received: from wolff.to ([66.93.197.194]:52921 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754858AbXJ2TmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:42:03 -0400
X-Greylist: delayed 2345 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 15:42:01 EDT
Date: Mon, 29 Oct 2007 13:55:22 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: linux-kernel@vger.kernel.org
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20071029185522.GB30571@wolff.to>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org> <Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 16:58:15 +0100,
  Hugh Dickins <hugh@veritas.com> wrote:
> 
> But once I look harder at it, I wonder what would have kept
> 2.6.18 to 2.6.23 safe from the same issue: per-cpu deltas from
> the global vm stats too low to get synched back to global, yet
> adding up to something which misleads balance_dirty_pages into
> an indefinite loop e.g. total nr_writeback actually 0, but
> appearing more than dirty_thresh in the global approximation.

I have been seeing this problem since Fedora Core 5's 2.6.20-1.2300.fc5
kernel. The last Fedora kernel that didn't have this problem was
2.6.19-1.2288.2.4.fc5, which I am still running on one machine.

I have put up vmstat and proc/meminfo data at: http://wolff.to/bruno/vmlog
There are a number of iterations of the output and they are mixed together,
though the vmstat info was written when a buffer was full, so there are
chunks of lines together. This was from a machine running Fedora 7's
2.6.23.1-4.fc7 kernel.

The machine is a single processor P3 with 512 MB of memory. There are
three hard drives, two of which are used in software raid 1 arrays.
I have ext3 file systems mounted noatime. I can provide more details if
you need anything else.

I can get lockups to happen fairly often. Often lots of firefox activity
and/or some other disk heavy task such as yum update will get it to happen.

I am not subscribed to LMKL, so please keep me copied on replies.
