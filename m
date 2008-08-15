Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYHONqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYHONqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYHONpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:45:51 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37480 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753422AbYHONpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:45:50 -0400
Date: Fri, 15 Aug 2008 09:45:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080815134545.GM13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com> <20080814234458.GD13048@mit.edu> <1218762627.15342.447.camel@think.oraclecorp.com> <1218804361.15342.470.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218804361.15342.470.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 08:46:01AM -0400, Chris Mason wrote:
> Whoops the link above is wrong, try:
> 
> http://oss.oracle.com/~mason/compilebench

Thanks, I figured it out.

> It is worth noting that the end throughput doesn't matter quite as much
> as the writeback pattern.  Ext4 is pretty solid on this test, with very
> consistent results.

There were two reasons why I wanted to play with compilebench.  The
first is we have a fragmentation problem with delayed allocation and
small files getting forced out due to memory pressure, that we've been
working for the past week.  My intuition (which has proven to be
correct) is that compilebench is a great tool to show it off.  It may
not matter so much for write throughput results, since usually the
separation distance between the first block and the rest of the file
is small, and the write elevator takes care of it, but in the long run
this kind of allocation pattern is no good:

Inode 221280: (0):887097, (1):882497
Inode 221282: (0):887098, (1-2):882498-882499
Inode 221284: (0):887099, (1):882500

The other reason why I was interested in playing with compilebench
tool is that I wanted to try tweaking the commit timers to see if this
would make a difference to the result.  Not for this benchmark, it
appears, given a quick test that I did last night.

						 - Ted

