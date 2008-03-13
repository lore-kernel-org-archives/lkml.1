Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYCMRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYCMRER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYCMREG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:04:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYCMREE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:04:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Thu, 13 Mar 2008 18:03:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org> <200803122253.07631.rjw@sisk.pl> <m1iqzrxy26.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1iqzrxy26.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200803131803.31120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of March 2008, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Yes, it ought to be possible.
> >
> > Ultimately, IMHO, we should put all devices unnecessary for saving the image
> > (and doing some eye-candy work) into low power states before the image is
> > created and keep them in low power states until the system is eventually
> > powered off.
> 
> Why?  I guess I don't see why we care what power state the devices are in.
> Especially since we should be able to quickly save the image.
> 
> We need to disconnect the drivers from the hardware yes.  So filesystems
> still work and applications that do direct hardware access still work
> and don't need to reopen their connections.
> 
> I'm leery of low power states as they don't always work, and bringing
> low power states seems to confuse hibernation to disk with suspend to
> ram.

>From the ACPI compliance point of view it's better to do it this way.  We need
to put the devices into low power states anyway before "powering off" the
system and we won't need to touch them for the second time if we do that
in advance.

Still, it would be sufficient if we disconnected the drivers from the hardware
and thus prevented applications from accessing that hardware.

Thanks,
Rafael
