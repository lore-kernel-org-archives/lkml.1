Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbYDQRfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbYDQRfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbYDQRew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:34:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbYDQRev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:34:51 -0400
Date: Thu, 17 Apr 2008 13:29:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kenichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Subject: Re: vmcoreinfo: add the symbol "phys_base"
Message-ID: <20080417172935.GA3708@redhat.com>
References: <20080417010122.148289106@sous-sol.org> <20080417010334.951283202@sous-sol.org> <m17iewvnot.fsf@frodo.ebiederm.org> <20080417171616.GE17220@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417171616.GE17220@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 10:16:16AM -0700, Chris Wright wrote:
> * Eric W. Biederman (ebiederm@xmission.com) wrote:
> > Chris Wright <chrisw@sous-sol.org> writes:
> > 
> > > -stable review patch.  If anyone has any objections, please let us know.
> > > ---------------------
> > 
> > This patch seems quite reasonable.  However as I read it, it is
> > a feature enhancement, that allows a user space tool to function
> > better.  Do we backport trivial features into stable now?
> 
> Function better, meaning work reliably?  Sounds like a fix not a
> feature.
> 

I think in theory, makedumpfile should be able to guess phys_base by
looking at the vmcore ELF headers (Look for program headers which are
mapping kernel text and data and look at respective virtual address and
physical addresses.).

I think this patch just makes it explicit instead putting extra logic
for guessing the things.

To make sure makedumpfile is not broken with older kernels (in specific
configurations where phys_base is not zero), I think one can also modify
makedumpfile but I don't see any harm in putting this small change
in stable kernel.

Keni'chi, can you please throw some light here if makedumpfile is broken with
stable kernel or not (with phys_base not being zero).

Thanks
Vivek
