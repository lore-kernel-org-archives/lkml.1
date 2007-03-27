Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXC0NaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXC0NaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbXC0NaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:30:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55192 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbXC0N37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:29:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Marcus Better <marcus@better.se>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070327015949.GB16477@stusta.de>
	<200703271000.05341.marcus@better.se>
Date: Tue, 27 Mar 2007 07:25:12 -0600
In-Reply-To: <200703271000.05341.marcus@better.se> (Marcus Better's message of
	"Tue, 27 Mar 2007 10:00:02 +0200")
Message-ID: <m13b3qzumf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Better <marcus@better.se> writes:

>> Subject    : second suspend to disk in a row results in an oops  (MSI)
>> References : http://lkml.org/lkml/2007/3/17/43
>>              http://lkml.org/lkml/2007/3/22/150
>>              http://lkml.org/lkml/2007/3/26/205
>>              http://lkml.org/lkml/2007/3/26/76
>> Submitter  : Thomas Meyer <thomas@m3y3r.de>
>>              Frédéric Riss <frederic.riss@gmail.com>
>>              Marcus Better <marcus@better.se>
>> Handled-By : Eric W. Biederman <ebiederm@xmission.com>
>> Patch      : http://lkml.org/lkml/2007/3/24/136
>> Status     : patch was suggested
>
> For the sake of completeness, my bisection resulted in this:
>
> 392ee1e6dd901db6c4504617476f6442ed91f72d is first bad commit
> commit 392ee1e6dd901db6c4504617476f6442ed91f72d
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Thu Mar 8 13:04:57 2007 -0700
>
>     [PATCH] msi: Safer state caching.

Right.  However if this is what Thomas was seeing the problem turned
out to be an issue with pci_enable_device changing the irq number.
It just happens that now the code cares, so the bug is found.

Marcus any chance I could see an oops?  Or you could try the patch I
previously posted when debugging this with Thomas.

I'm going to clean that patch up and send it along in hopes that it
helps anyway and see where we land.

Eric
