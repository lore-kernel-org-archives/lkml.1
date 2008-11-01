Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYKACeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYKACeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 22:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYKACeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 22:34:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:50254 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYKACeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 22:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:x-gpg-fingerprint:user-agent
         :message-id;
        b=NGnKBx0GNRCStvbXKk3MVv0yqzYlw0wUw1zdco92AEzZRYT2j4gnFKrs7O6q9MNCkn
         xtbm2CtcMR0M5pyDiTCejcDTUZBChh3W5U7Xlm0+H4tnYpdP7F4lpMVT2cu4lNyIksVs
         lUtaIv0JeuxGD0qt7tRbask5z1mo+wNLex3E8=
Date: Sat, 1 Nov 2008 10:33:58 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: John Galloway <John.Galloway@ingres.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: readahead in the 2.6.25+ kernel
References: <ABB90CDC9A08FF49851AC42557795A1802E6288D@USINVMAILB01.ingres.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABB90CDC9A08FF49851AC42557795A1802E6288D@USINVMAILB01.ingres.prv>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-Id: <1225506841.225780.4979@de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Fri, Oct 31, 2008 at 09:00:30PM -0400, John Galloway wrote:
> 
> Hi,
> 
>   I'm looking into read ahead issues wrt Ingres, particularly wrt mmap.
> I gather (but am not sure) your readahead patches have been incorporated
> into the 2.6 kernel around 2.6.15, with some simplfications it seems??
> Are you still maintaining a distinct patch set?

The ondemand readahead patch series have been merged into linux 2.6.23/24.
So I no longer maintain out-of-tree readahead patches.

>   And can you help me out about how linux readahead will effect mmap() as
> opposed to read()?  i.e. is it enabled for mmap() as well?

No, mmap readahead is always a dumb and simple 'read-around' one, and
it seems there is no general interest on improving it.

Currently you have two options to affect mmap readahead performance:
- tune readahead size with command `blockdev --setra'
- tell kernel to use the ondemand readahead routines with
  madvise(MADV_SEQUENTIAL)

Note that MADV_SEQUENTIAL is safe to use at least for the current
readahead implementation, it won't blindly do aggressive readahead on
seeing MADV_SEQUENTIAL. The flag only switches the readahead routine
from the dumb read-around one to the somehow smarter readahead logic,
which _detects_ sequential patterns for us.

As a long term solution, if you get favorable numbers with MADV_SEQUENTIAL,
that could be a 'first impetus' to improve the default mmap readahead code ;-)

Cheers,
Fengguang

