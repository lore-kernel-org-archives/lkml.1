Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXF2FBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXF2FBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXF2FBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:01:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41993 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053AbXF2FA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:00:59 -0400
Date: Fri, 29 Jun 2007 15:00:24 +1000
From: David Chinner <dgc@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, David Chinner <dgc@sgi.com>,
       linux-pm <linux-pm@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       David Robinson <zxvdr.au@gmail.com>, David Greaves <david@dgreaves.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070629050024.GO31489@sgi.com>
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706290016.45719.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 12:16:44AM +0200, Rafael J. Wysocki wrote:
> There are two solutions possible, IMO.  One would be to make these workqueues
> freezable, which is possible, but hacky and Oleg didn't like that very much.
> The second would be to freeze XFS from within the hibernation code path,
> using freeze_bdev().

The second is much more likely to work reliably. If freezing the
filesystem leaves something in an inconsistent state, then it's
something I can reproduce and debug without needing to
suspend/resume.

FWIW, don't forget you need to thaw the filesystem on resume.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
