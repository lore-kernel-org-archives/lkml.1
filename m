Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbZAUEDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbZAUEDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbZAUEDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:03:38 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:20496 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757666AbZAUEDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:03:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=F8ifLUaSCAgqpVCBqX1UBUPjG3IIqx3kQbItJROTzkKwBQzfDEsvrha9i7LSmUWp69EDyK5g+Mv3VIf8cXYRrkviGkRchDZcluj4UYP0huZ155qMXXiyPzLLQRq7sbSerywPMu5gCfv1hKgwSjf6uzONZ04HMgRrmcF+NjC8rQQ=  ;
X-YMail-OSG: MUPPmW0VM1kcy5XVvgiVKFfLCGAyfzLIiI66ry43vWqQtrdAF2_nqOWwk4UtIEcZCooOU1JKqEfejPnM2P2AdzTO0gl57p.dAUT9WpTrSjYgdNycPCxED16.Yss4D.NjA.oWE58krimjCjcL7Rb921hWXEloOpe5kxZ3c2ij29KpMpYleo5Bv3m2Q2iHwg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted XFS log replay oops. (was Re: Warning and BUG with btrfs and corrupted image)
Date: Wed, 21 Jan 2009 15:03:06 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@yahoo.com.au, xfs@oss.sgi.com
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed>
In-Reply-To: <20090121035703.GH10158@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211503.07308.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009 14:57:03 Dave Chinner wrote:
> [drop btrfs list from this thread]
>
> On Tue, Jan 20, 2009 at 06:34:55PM +0100, Eric Sesterhenn wrote:

> > [  235.250167] ------------[ cut here ]------------
> > [  235.250354] kernel BUG at mm/vmalloc.c:164!
> > [  235.250478] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> > [  235.250869] last sysfs file: /sys/block/ram9/range
> > [  235.250998] Modules linked in:
> > [  235.251037]
> > [  235.251037] Pid: 5352, comm: mount Not tainted
> > (2.6.29-rc2-00021-gd84d31c #216) System Name
> > [  235.251037] EIP: 0060:[<c0182af1>] EFLAGS: 00010246 CPU: 0
> > [  235.251037] EIP is at vmap_page_range+0x19/0x112
> > [  235.251037] EAX: d1000000 EBX: d1000000 ECX: 00000163 EDX: d1000000
> > [  235.251037] ESI: 00000003 EDI: d1000000 EBP: cbbd2c08 ESP: cbbd2be8
> > [  235.251037]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > [  235.251037] Process mount (pid: 5352, ti=cbbd2000 task=cbb85b00
> > task.ti=cbbd2000)
> > [  235.251037] Stack:
> > [  235.251037]  00000246 cbb85b00 00000163 c01414cf cbbd2c0c d1000000
> > 00000003 cba0f810
> > [  235.251037]  cbbd2c40 c018367c c848e280 00100000 00000000 c848e280
> > 00000000 00000014
> > [  235.251037]  d1000000 cba0f944 00000000 c848e160 00000000 c848e160
> > cbbd2c54 c03b2e1e
> > [  235.251037] Call Trace:
> > [  235.251037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
> > [  235.251037]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
> > [  235.251037]  [<c03b2e1e>] ? _xfs_buf_map_pages+0x42/0x6d
> > [  235.251037]  [<c03b3773>] ? xfs_buf_get_noaddr+0xbc/0x11f
> > [  235.251037]  [<c03a2406>] ? xlog_get_bp+0x5a/0x5d
> > [  235.251037]  [<c03a28fa>] ? xlog_find_verify_log_record+0x26/0x208
> > [  235.251037]  [<c03a3521>] ? xlog_find_zeroed+0x1d6/0x214
> > [  235.251037]  [<c03a3584>] ? xlog_find_head+0x25/0x358
>
> .....
>
> Ok, that's crashing in the new vmap code. It might take a couple
> of days before I get a chance to look at this, but I've cc'd Nick Piggin
> in case he has a chance to look at it before that. It's probably
> an XFS bug, anyway.

Hmm, it is crashing in BUG_ON(addr >= end); where this could happen
if XFS asks to map a really huge (or -ve) number of pages and wraps
the range, or if vmap subsystem returns an address right near the
end of the address range and addr+size wraps (which would be a bug
in vmap of course, but I think maybe less likely).

Printing out the values for addr and end might be instructive (XFS
might be asking to map -ERRNO pages or something).

