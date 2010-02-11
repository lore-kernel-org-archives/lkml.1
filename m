Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab0BKXRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:17:50 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54207 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0BKXRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:17:49 -0500
To: Greg KH <gregkh@suse.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Better sysfs lockdep
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <4B73671E.2050105@kernel.org> (Tejun Heo's message of "Thu\, 11 Feb 2010 11\:10\:38 +0900")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Thu, 11 Feb 2010 15:17:45 -0800
Message-ID: <m1r5orweee.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It turns out that it is pretty simple to rework the lockdep support
to give each sysfs attribute it's own lockdep class, which should
kill the annoying false positives we have been seeing lately.

The one caveat is that it requires dynamically allocated sysfs
attributes to be explicitly initialized.  Luckily it is brainless
trivial whack-a-mole and took maybe 15 minutes to find all of the
dynamically allocates sysfs attributes on my test machine, because
the errors show up when the attributes are registered with sysfs,
and all of the fixes are one-liners.

Hopefully with this we can head back to fixing the real issues.

Eric
