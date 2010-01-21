Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719Ab0AUBcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0AUBcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327Ab0AUBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:32:16 -0500
Received: from mail2.shareable.org ([80.68.89.115]:50545 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0AUBcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:32:15 -0500
Date: Thu, 21 Jan 2010 01:32:05 +0000
From: Jamie Lokier <jamie@shareable.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: anfei <anfei.zhou@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux@arm.linux.org.uk
Subject: Re: cache alias in mmap + write
Message-ID: <20100121013205.GA29808@shareable.org>
References: <20100120174630.4071.A69D9226@jp.fujitsu.com> <20100120095242.GA5672@desktop> <20100121094733.3778.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100121094733.3778.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>  2. Add some commnet. almost developer only have x86 machine. so, arm
>     specific trick need additional explicit explanation. otherwise anybody
>     might break this code in the future.

That's Documentation/cachetlb.txt.

What's being discussed here is not ARM-specific, although it appears
maintainers of different architecture (ARM and MIPS for a start) may
have different ideas about what they are guaranteeing to userspace.
It sounds like MIPS expects userspace to use msync() sometimes (even
though Linux msync(MS_INVALIDATE) is quite broken), and ARM expects to
to keep mappings coherent automatically (which is sometimes slower
than necessary, but usually very helpful).

>  3. Resend the patch. original mail isn't good patch format. please
>  consider to reduce akpm suffer.

This type of change in generic code would need review from a number of
architecture maintainers, I'd expect.

-- Jamie
