Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbXD0SNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbXD0SNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbXD0SNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:13:00 -0400
Received: from holomorphy.com ([66.93.40.71]:46138 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbXD0SM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:12:59 -0400
Date: Fri, 27 Apr 2007 11:12:56 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427181256.GR19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <20070427165522.GI24852@thunk.org> <1177695127.3119.1.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177695127.3119.1.camel@entropy>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 12:55 -0400, Theodore Tso wrote:
>> Unfortunately, this isn't a problem with hardware getting better, but
>> a willingness to break backwards compatibility.
>> x86_64 uses a 4k page size to avoid breaking 32-bit applications.  And
>> unfortunately, iirc, even 64-bit applications are continuing to depend
>> on 4k page alignments for things like the text and bss segments.  If
>> the userspace ELF and other compiler/linker specifications were
>> appropriate written so they could handle 16k pagesizes, maybe 5 years
>> from now we could move to a 16k pagesize.  But this is going to
>> require some coordination between the userspace binutils folks and
>> AMD/Intel in order to plan such a migration.

On Fri, Apr 27, 2007 at 10:32:07AM -0700, Nicholas Miell wrote:
> The AMD64 psABI requires binaries to work with any page size up to 64k.
> Whether that's true in practice is another matter entirely, of course.

64-bit applications are a non-issue. The ABI requires them to handle it.
It's 32-bit applications on x86-64 that are the concern. ABI emulation
for them is more involved when 4K 32-bit ABI's are to be emulated on
kernels compiled for larger native pagesizes. In practice, so many use
getpagesize() it may not be much of an issue, but consider WINE and
other sorts of non-Linux-native 32-bit apps, among other issues.


-- wli
