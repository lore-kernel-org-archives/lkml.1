Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYCMAix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYCMAix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYCMAin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:38:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51066 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYCMAin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:38:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org>
	<200803122253.07631.rjw@sisk.pl>
Date: Wed, 12 Mar 2008 18:33:21 -0600
In-Reply-To: <200803122253.07631.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 12 Mar 2008 22:53:06 +0100")
Message-ID: <m1iqzrxy26.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Yes, it ought to be possible.
>
> Ultimately, IMHO, we should put all devices unnecessary for saving the image
> (and doing some eye-candy work) into low power states before the image is
> created and keep them in low power states until the system is eventually
> powered off.

Why?  I guess I don't see why we care what power state the devices are in.
Especially since we should be able to quickly save the image.

We need to disconnect the drivers from the hardware yes.  So filesystems
still work and applications that do direct hardware access still work
and don't need to reopen their connections.

I'm leery of low power states as they don't always work, and bringing
low power states seems to confuse hibernation to disk with suspend to
ram.

> If this is done, the remaining problem is the handling of the devices that we
> need to save the image.  I believe that will be achievable without using the
> freezer.

Reasonable.  In general the problem is much easier if we don't store
the hibernation image in a filesystem or partition that the rest of
the system is using.  That way we avoid inconsistencies.

Eric
