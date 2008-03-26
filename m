Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYCZDCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYCZDCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYCZDCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:02:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59373 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750952AbYCZDC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:02:29 -0400
Date: Tue, 25 Mar 2008 22:02:26 -0500
From: Jack Steiner <steiner@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/8] x86_64: Add UV specific header for MMR definitions
Message-ID: <20080326030226.GA11714@sgi.com>
References: <20080324182116.GA28285@sgi.com> <20080325082756.GA6589@infradead.org> <87myoni0gp.fsf@basil.nowhere.org> <20080326000820.GA18701@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326000820.GA18701@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 08:08:20PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 25, 2008 at 11:04:22AM +0100, Andi Kleen wrote:
> > bitfields are only problematic on portable code, which this isn't.
> 
> it's still crappy to read and a bad example for others.  And last time
> I heard about UV it also included an ia64 version, but that's been
> loooong ago.

I agree that the format of the MMR definitions is not ideal. However,
the alternative of maintaining a 1-off set of MMR definitions is
not very attractive either. The definitions are auto-generated
by hardware design tools and the definitions are used by a number
of tools including diagnostics and BIOS. The definitions are still
changing. I _think_ the registers used by the OS are fairly stable
but there is no guarantee that there won't be additional changes.

The total size of the hardware generated files is over 200000 lines.
We have a tool that extracts the definition of registers used by
the OS. The tools also makes simple easy-to-debug formating
changes such as eliminating screwy type-casts and typedefs.

I would certainly like to keep the auto-generated definitions
and minimize the risk of introducing bugs by incorrectly
generating a one-off set of definitions. The number of files that
will use these definitions is small.


--- jack
