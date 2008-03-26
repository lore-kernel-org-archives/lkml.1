Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbYCZQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbYCZQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYCZQaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:30:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:45953 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbYCZQaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dVfxNkKYDST0oQ2StDkVnkuIcfZxMa38XVWsONqXXSpfLDD1QLZV9bS5cl5R7FyDO/mYh/6u0cakVZDtAi0lH9c0NxTpqk33DJKq5ehnRpGgFG7s9yh9G1hLNB/2E89G05NWcc+6YonjR1PusTUT23H/RH6TIRgPVU/iew9acbY=
Message-ID: <2c0942db0803260930y741dfe81r114bd18b35e0bbe5@mail.gmail.com>
Date: Wed, 26 Mar 2008 09:30:14 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Cc: LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <200803220259.48534.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803220259.48534.rjw@sisk.pl>
X-Google-Sender-Auth: 0af7c0e65f5aa038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/21 Rafael J. Wysocki <rjw@sisk.pl>:
> This message contains a list of some regressions from 2.6.24 reported since
>  2.6.25-rc1 was released, for which there are no fixes in the mainline I know
>  of.  If any of them have been fixed already, please let me know.
[...]
>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10041
>  Subject         : 2.6.25-rc1/2 regression: first-time login into gnome fails
>  Submitter       : Romano Giannetti <romanol@upcomillas.es>
>  Date            : 2008-02-18 11:56 (33 days old)
>  References      : http://lkml.org/lkml/2008/2/18/145
>  Handled-By      : Ray Lee <ray-lk@madrabbit.org>

This appears to be a race in user space that people have been hitting
for some time, but has gotten more likely with the latest kernel. It
matches the behavior of a gnome dbus bug [
http://bugzilla.gnome.org/show_bug.cgi?id=395488 ]. The way to avoid
that bug is to install the dbus-x11 package which forces dbus to start
up earlier, avoiding the race.

Though the original reporter hasn't replied, Christoph Hellwig hit the
same issue and was able to confirm that installing the dbus-x11
package avoids the issue, papering over bug, wherever it may lie.
Regardless, there are reports of this issue that go back before
2.6.25, so I don't think this is a regression, just a timing issue
that's a lot easier to hit with the latest kernel.

This is one of those things that'd be nice to have in a Known Issues
document in the kernel release. "Debian and derivative distributions
may need to install dbus-x11 package to avoid a known userspace issue
in the dbus package. [gnome bug 395488]"
