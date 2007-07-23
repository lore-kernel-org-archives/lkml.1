Return-Path: <linux-kernel-owner+w=401wt.eu-S935653AbXGWUim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935653AbXGWUim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXGWUif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:38:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46276 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbXGWUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:38:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: "Latchesar Ionkov" <lucho@ionkov.net>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl numbers.)
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
	<20070721205709.GB5772@martell.zuzino.mipt.ru>
	<m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
	<a4e6962a0707231013v47683cd0xd35c65c25cb40653@mail.gmail.com>
	<f158dc670707231105o18fa3f63j194285547493f04a@mail.gmail.com>
	<a4e6962a0707231109r332e8d8ft791c947b421ead0e@mail.gmail.com>
Date: Mon, 23 Jul 2007 14:37:48 -0600
In-Reply-To: <a4e6962a0707231109r332e8d8ft791c947b421ead0e@mail.gmail.com>
	(Eric Van Hensbergen's message of "Mon, 23 Jul 2007 13:09:18 -0500")
Message-ID: <m13azex3dv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Eric Van Hensbergen" <ericvh@gmail.com> writes:

> On 7/23/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
>> It doesn't really matter (for me) whether it is sysctl or sysfs
>> interface. The sysctl approach seemed easier to implement. If the
>> consensus is to use sysfs, I'll send a patch (for 2.6.24).
>>
>> Sorry for the incorrect implementation, I guess I stole the code from
>> unappropriate place :)
>>
>
> I think this is appropriate for a "fix" submission to the 2.6.23-rc
> series.  If you don't have the bandwidth right now, I'll look at
> reworking it, or at the very least just removing the sysctl interface.

For something this simple I don't see a problem with using sysctl
as it is simple and stupid, and generally easy to implement.  If you
had value per filesystem you would want things as mount options or
someplace else but for a global tunable sysctl is decent (although it
doesn't do much for locking).

The practical issue is that sysctl has two places it shows up.

/proc/sys/...  (very unix/plan9 ish)
sys_sysctl()  (not very unixish and not barely used).

Currently allocating binary numbers so you can use the sys_sysctl
interface is not required.  And it doesn't look interesting in your
case.

So all I'm asking is that you don't allocate binary numbers for
sys_sysctl.  As odds are no one is going to use them anyway.

The binary numbers you are using were not reserved in sysctl.h
so they were not reserved properly (a bug).

My patch simply removes the attempt to provide binary numbers for
sys_sysctl(), but keeps the good unixish /proc/sys parts.

If sysfs provides some cool widgetry that really helps go for it
but I would actually be surprised in this context if it does.

Eric
