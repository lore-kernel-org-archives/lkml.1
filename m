Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXEIK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXEIK3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXEIK2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:28:44 -0400
Received: from lazybastard.de ([212.112.238.170]:59883 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbXEIK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:28:42 -0400
Date: Wed, 9 May 2007 12:24:24 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070509102424.GB29978@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <20070508163226.GA22443@lazybastard.org> <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com> <20070508205827.GC23056@lazybastard.org> <20070508225253.GA2689@kroah.com> <20070508231009.GB25920@lazybastard.org> <20070509000101.GB3967@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070509000101.GB3967@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 17:01:01 -0700, Greg KH wrote:
> On Wed, May 09, 2007 at 01:10:09AM +0200, J??rn Engel wrote:
> > 
> > The remaining question is how to deal with kernel-only code that uses
> > be64.  Convert that to __be64 as well?  Or introduce be64 in
> > include/linix/types.h instead?
> 
> I say leave it alone for now, it's not that common :)

Using a fairly lame grep, there are 10k instances versus 60k for u64 and
friends.  Sustract about 2.5k used in include/ and possibly part of
userspace interfaces, that leaves about 7.5k.

joern@Galway:/usr/src/kernel/logfs$ sgrep '\<u[136][246]\>' .|wc
  60306  313780 3960665
joern@Galway:/usr/src/kernel/logfs$ sgrep '\<__[lb]e[136][246]\>' .|wc
  10013   52235  635047
joern@Galway:/usr/src/kernel/logfs$ sgrep '\<__[lb]e[136][246]\>' include|wc
   2624   15100  173176

Actually going through them all, the overwhelming majority is used for
structures.  I seem to be quite the oddball indeed.

Will change.

Jörn

-- 
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
