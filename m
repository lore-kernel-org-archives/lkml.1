Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120Ab0ANHD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0ANHD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904Ab0ANHD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:03:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0ANHD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:03:28 -0500
Message-ID: <4B4EC1A5.4010701@zytor.com>
Date: Wed, 13 Jan 2010 23:03:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up rwsem type system
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <4B4D1865.5000107@zytor.com> <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain> <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain> <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain> <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 06:16 PM, Linus Torvalds wrote:
> 
> In case anybody wants to test, the final piece is appended.
> 
> Again, note the 32767-thread limit here. So this really does need that 
> whole "make rwsem_count_t be 64-bit and fix the BIAS values to match" 
> extension on top of it, but that is conceptually a totally independent 
> issue.
> 
> NOT TESTED! The original patch that this all was based on were tested by 
> KAMEZAWA Hiroyuki, but maybe I screwed up something when I created the 
> cleaned-up series, so caveat emptor..
> 
> Also note that it _may_ be a good idea to mark some more registers 
> clobbered on x86-64 in the inline asms instead of saving/restoring them. 
> They are inline functions, but they are only used in places where there 
> are not a lot of live registers _anyway_, so doing for example the 
> clobbers of %r8-%r11 in the asm wouldn't make the fast-path code any 
> worse, and would make the slow-path code smaller. 
> 

Hi Linus,

I have put these into a separate topic branch in the tip tree, which
should get them some test coverage.  I will look at 64-bit counters to
support 2^31 threads hopefully later this week, unless you prefer to do
it yourself.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

