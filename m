Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZL2Slg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZL2Slg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZL2Sle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:41:34 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:32973 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbZL2Sle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:41:34 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [Bug #14730] sky2 won't work after suspend/resume cycle
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	<srmJ8vMxKPH.A.6LD.JxhOLB@chimera>
Date: Wed, 30 Dec 2009 03:41:30 +0900
In-Reply-To: <srmJ8vMxKPH.A.6LD.JxhOLB@chimera> (Rafael J. Wysocki's message
	of "Tue, 29 Dec 2009 16:28:47 +0100 (CET)")
Message-ID: <878wcltyg5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14730
> Subject		: sky2 won't work after suspend/resume cycle
> Submitter	: Maciej J. Woloszyk <mat@esi.com.pl>
> Date		: 2009-12-04 09:02 (26 days old)

This seems to be related to commit 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff.

It clears dev->state_saved blindly, but pci_pm_resume() calls
pci_restore_standard_config() before pm->resume() (by probably
historical reason).

So, I guess it became the cause of restore regression before changing
PCI power state. It might be better to revert
4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff for now, until changing pci
generic stuff.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
