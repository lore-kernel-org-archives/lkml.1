Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXFZK5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXFZK5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXFZK5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:57:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59867 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXFZK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:57:14 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070626100628.GO24183@enneenne.com>
References: <20070626100628.GO24183@enneenne.com>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 11:57:07 +0100
Message-Id: <1182855427.12109.203.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 12:06 +0200, Rodolfo Giometti wrote:
> Hello,
> 
> here my new version of LinuxPPS with a new syscalls API.
> 
> Please take a look at this new patch and report any
> suggestions/modifications so I can prepare a proper patch for kernel
> inclusion.

Your syscalls blindly dereference userspace pointers instead of using
copy_{to,from} user.

Why did you split all your syscalls into two functions?

s/__FUNCTION__/__func__/

s/antennas/antennae/

You seem to have added debugging messages mentioning 'serial8250' into
serial_core.h

You added <linux/pps.h> with #ifdef __KERNEL__ in it, but didn't export
it to userspace. Why?

Your structures for userspace communication look OK -- I don't think you
need special 32/64 compatibility for them. You do need it for the
'struct timespec' in sys_time_pps_fetch() though.

Must we have the ioctl-like interface to sys_time_pps_cmd()? If the
second argument is always 'struct pps_source_data_s *', why does the
syscall pretend it's 'void *'?

-- 
dwmw2

