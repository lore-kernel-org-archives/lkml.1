Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbXGPNdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbXGPNdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbXGPNdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:33:23 -0400
Received: from [212.12.190.118] ([212.12.190.118]:32923 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758779AbXGPNdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:33:22 -0400
From: Al Boldi <a1426z@gawab.com>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Mon, 16 Jul 2007 16:32:02 +0300
User-Agent: KMail/1.5
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org> <200707160802.46567.a1426z@gawab.com> <Pine.LNX.4.64.0707152342140.19248@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707152342140.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707161632.02334.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 16 Jul 2007, Al Boldi wrote:
> > david@lang.hm wrote:
> >> suspend-to-RAM should not involve kexec, the only reason for doing the
> >> kexec to to get a seperate userspace to use for suspend-to-disk
> >> operations instead of trying to partially freeze the sustem and keep
> >> useing it.
> >
> > Or you could do suspend-to-disk-and-RAM.  But in the above case, it was
> > meant to test kexec compatibility with device suspend/resume calls.
>
> the point I am trying to make here is that there is no reason that the
> kexec approach needs to do _any_ suspend/resume calls.

When you go through ACPI, then that implies calling suspend/resume calls.

> all that is needed is the ability of the new kernel to initialize the
> devices it needs.

We have to go through ACPI, for wakeup functions to succeed.  A simple 
power-off won't do.

> suspend-to-disk-and-ram could be implemented as three
> seperate steps
>
> 1. suspend-to-disk
>
> 2. resume-from-disk
>
> 3. suspend-to-ram
>
> followed by either
>
> 4. resume-from-ram
>
> or
>
> 4. battery dies and loptop powers off completely
>
> 5. power-on boot.
>
> 6. resume-from-disk
>
> all that you need to do is to make sure that the system doesn't run
> anything that would affect permanent media or the outside world between
> steps #2 and #3

Exactly, which is why your scheme would break down on #3, and that's why you 
need to call S3 from within the kexec'd hibernation kernel after saving the 
hibernation image.


Thanks!

--
Al

