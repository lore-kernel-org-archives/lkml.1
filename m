Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbZL2WIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZL2WIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZL2WIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:08:35 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:43086 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZL2WIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:08:35 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [Bug #14730] sky2 won't work after suspend/resume cycle
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	<srmJ8vMxKPH.A.6LD.JxhOLB@chimera>
	<878wcltyg5.fsf@devron.myhome.or.jp> <200912292229.47644.rjw@sisk.pl>
Date: Wed, 30 Dec 2009 07:08:30 +0900
In-Reply-To: <200912292229.47644.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 29 Dec 2009 22:29:47 +0100")
Message-ID: <874on9tov5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 29 December 2009, OGAWA Hirofumi wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.31 and 2.6.32.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> > be listed and let me know (either way).
>> >
>> >
>> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14730
>> > Subject		: sky2 won't work after suspend/resume cycle
>> > Submitter	: Maciej J. Woloszyk <mat@esi.com.pl>
>> > Date		: 2009-12-04 09:02 (26 days old)
>> 
>> This seems to be related to commit 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff.
>> 
>> It clears dev->state_saved blindly, but pci_pm_resume() calls
>> pci_restore_standard_config() before pm->resume() (by probably
>> historical reason).
>
> The other way around.  pci_restore_standard_config() is the new thing and the
> pci_restore_state() in ->resume() is supposed to be unnecessary.  Unfortunately
> in this case the restoration of PCI config registers in
> pci_restore_standard_config() doesn't work.
>
> I'd like to understand the reason, but temporarily we can just set
> pdev->state_saved to 1 in sky2_resume(), as proposed in the bug entry.

Sure. However, it might not be only sky2. Well, anyway, another likely
one is - restore() should be called after pci_pm_default_resume()?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
