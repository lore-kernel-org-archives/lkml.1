Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXFTA2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXFTA2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 20:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXFTA2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 20:28:05 -0400
Received: from pat.uio.no ([129.240.10.15]:36880 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbXFTA2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 20:28:04 -0400
Subject: Re: Versioning file system
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, akpm@linux-foundation.org,
       alan <alan@clueserver.org>, Chris Snook <csnook@redhat.com>,
       hpa@zytor.com, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <OF35839FC7.229AE944-ON882572FF.007F2DF8-882572FF.00819E1C@us.ibm.com>
References: <OF35839FC7.229AE944-ON882572FF.007F2DF8-882572FF.00819E1C@us.ibm.com>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 20:27:43 -0400
Message-Id: <1182299263.6504.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.087)
X-UiO-Scanned: 82AF3138B4984AA9391BFA8322EE86C5B4319295
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 96 total 2463198 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 16:35 -0700, Bryan Henderson wrote:
> >We don't need a new special character for every 
> >>  new feature.  We've got one, and it's flexible enough to do what you 
> want, 
> >> as proven by NetApp's extremely successful implementation.
> 
> I don't know NetApp's implementation, but I assume it is more than just a 
> choice of special character.  If you merely start the directory name with 
> a dot, you don't fool anyone but 'ls' and shell wildcard expansion.  (And 
> for some enlightened people like me, you don't even fool ls, because we 
> use the --almost-all option to show the dot files by default, having been 
> burned too many times by invisible files).
> 
> I assume NetApp flags the directory specially so that a POSIX directory 
> read doesn't get it.  I've seen that done elsewhere.

No. The directory is quite visible with a standard 'ls -a'. Instead,
they simply mark it as a separate volume/filesystem: i.e. the fsid
differs when you call stat(). The whole thing ends up acting rather like
our bind mounts.
It means that you avoid all those nasty user issues where people try to
hard link to/from .snapshot directories, rename files across snapshot
boundaries, etc.

Trond

