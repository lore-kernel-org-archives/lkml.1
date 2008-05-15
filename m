Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYEOW2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYEOW2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYEOW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:28:13 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58336 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbYEOW2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:28:12 -0400
Date: Thu, 15 May 2008 18:27:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080515222741.GQ18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, mpm@selenic.com
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515215517.GI1936@cs181133002.pp.htv.fi> <482CB354.3010205@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CB354.3010205@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:04:04PM -0400, Jeff Garzik wrote:
>> I have seen embedded systems with zero entropy, and dubious entropy might 
>> there be better than no entropy at all.
>> Or am I wrong on the latter?
>
> It's also relevant to the discussion to note that input data to kernel 
> devrandom is mixed, and we can control the amount of "credit" applied to 
> incoming entropy.

Sure, and one possible thing to do is to simply always input the
interrupt information to the random number generator, but give it a
"entropy credit" of 0.  That has the net result of potentially
improving the entropy found in /dev/random and /dev/urandom, but not
necessarily compromising /dev/random, since /dev/random's output is
throttled by the entropy estimate.

The only cost of doing this would be the overhead in sending the
information into the entropy pool.

						- Ted
