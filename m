Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZKDCSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZKDCSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZKDCSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:18:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44410 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZKDCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:18:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed s2disk/ram cycle
Cc: kosaki.motohiro@jp.fujitsu.com, Daniel Pittman <daniel@rimspace.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091007161604.GA28849@infradead.org>
References: <87vdisq7bh.fsf@rimspace.net> <20091007161604.GA28849@infradead.org>
Message-Id: <20091104111125.54C3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  4 Nov 2009 11:18:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Oct 07, 2009 at 01:14:10PM +1100, Daniel Pittman wrote:
> > For what it is worth, I would also be quite interested to know /why/ XFS is
> > bad in this regard.  Is it just the previously stated "XFS writes to disk
> > despite freezing kernel threads" issue, or something deeper?
> 
> sync pushes out all data to disk, but in a journaling filesystem that
> might just but the log not the "normal" place on disk.  For a boot
> loader to deal with it properly it actually needs to do an replay of
> the log.  Grub does so for reiserfs but not for XFS for some reason.
> I don't know why problems don't trigger more often with ext3, though.

I'm sorry for the long delayed and offtopic responce. I discussed this
issue with okuji-san (GRUB2 maintainer) at several month ago.
He really wish linux implement real sync.

A bootloader has much constraint than OS (mainly caused by size constraint).
it can't implemnt jornal log replay logic for _all_ filesystem. Why can't we
implement storong sync syscall? I don't think this is PM nor bootloader fault.


