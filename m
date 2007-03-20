Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXCTUeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXCTUeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXCTUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:34:17 -0400
Received: from sccrmhc13.comcast.net ([63.240.77.83]:55197 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbXCTUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:34:16 -0400
Subject: Re: BSOD
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, jesse.barnes@intel.com,
       zaitcev@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <17919.42767.233797.860230@cargo.ozlabs.ibm.com>
References: <20070319120807.af36ef5d.zaitcev@redhat.com>
	 <20070319.123836.39155546.davem@davemloft.net>
	 <200703191254.36373.jesse.barnes@intel.com>
	 <20070319.130544.115907938.davem@davemloft.net>
	 <17919.42767.233797.860230@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Organization: OLPC
Date: Tue, 20 Mar 2007 16:33:56 -0400
Message-Id: <1174422836.6832.313.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 20:19 +1100, Paul Mackerras wrote:

> Anything is better than nothing.  At the moment we get nothing if you
> are in X when the panic occurs, even for the nicest, most well-behaved
> panics. :)  If we can change that to getting something sometimes,
> that's a win.

Treating the display as a frame buffer if at all possible is more likely
to work than anything else.  All the kernel needs to know is beginning
address, stride (# bytes/line; not necessarily the same as the number of
pixels on a row), number of rows, and depth of the display.  Thereafter,
it's just a SMOP as they say (and the sometimes maligned fbdev driver of
course already has all this code, and usually oops messages do ok on
fbdev).  

The other interesting headache that comes up sometimes is when the oops
message is more than a screen-full long.

One may also need to reset lookup tables to some sane value, and halt
the GPU, and maybe worry about video overlays.
                                 - Jim


-- 
Jim Gettys
One Laptop Per Child


