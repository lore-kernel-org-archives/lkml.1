Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXJ1TVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXJ1TVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXJ1TVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:21:04 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:42571 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXJ1TVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:21:03 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=Bz23lN3FJovpvUefUV+aUHStG0OOUsQPZJAw+QaBS1oBeJUEEJ1vFJaiOeMMy3bT4/u3vixLfwt4zvRisDe218DLWIK8Wt5v0YiaqKealeV3sTm6Ex1ti8xDw+ZZs5hu;
X-IronPort-AV: E=Sophos;i="4.21,339,1188795600"; 
   d="scan'208";a="392569544"
Date: Sun, 28 Oct 2007 14:20:31 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: "lists@antonello.org" <lists@antonello.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Dell laptop backlight driver
Message-ID: <20071028192031.GA11442@auslistsprd01.us.dell.com>
References: <4724B4F5.80004@antonello.org> <20071028161955.GF23359@auslistsprd01.us.dell.com> <4724CF9F.6050908@antonello.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4724CF9F.6050908@antonello.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 07:06:23PM +0100, lists@antonello.org wrote:
> Matt Domsch wrote:
> >On Sun, Oct 28, 2007 at 05:12:37PM +0100, jack@antonello.org wrote:
> >>Hello,
> >>this driver implements backlight control on Dell laptops
> >>which use SMI  for changing brightness levels.
> >>
> >>The driver is INCOMPLETE since it is unable to probe some required 
> >>parameters
> >>in order to perform backlight control. Such parameters are found in a Dell
> >>proprietary DMI table which should be parsed. For now external tools may 
> >>be
> >>used to find these parameters by hand. So if you intend to try this out,
> >>FIRST write your laptop model parameters correctly inside the source code
> >>as explained in Documentation/dell-laptop.txt.
> >>
> >>Parts of this driver may also be used to provide additional 
> >>functionalities
> >>similarly to the drivers/misc/*-laptop.c drivers.
> >
> >Why is this better done in the kernel rather than in userspace with
> >libsmbios as you've noted?
> >
> 
> I had to do a kernelspace driver for controlling the backlight. This
> was part of a college project assignment. In order for it to be valid
> for an operating system course, it had to be in kernelspace (not
> Unix programming) :).
> 
> As i mentioned that can be done in userspace and it IS sensible to do
> so. I know that the code which was already written for Dell implied
> a userspace approach, but i simply had no choice.
> 
> I also don't expect this driver to become mainstream, but since i have
> written it, other people might want to have a look at it.

OK, that's fair.

 
> Finally i really don't think there's any sensible way of implementing
> Linux LCD Backlight Abstraction relying on a userspace application.
> That would mean the kernel calling userspace code to change the
> brightness, then this latter code would again call the kernel to trigger
> a SMI and so on. That's just not a good design. I think a userspace
> solution implies choosing NOT to implement the LCD Abstraction. Causing
> Dell laptops to be treated differently from other machines (as they are
> not compliant with Linux's own interface).

I've had this discussion on lkml before. Short story is, until Dell
laptops implement the ACPI methods that the backlight API expects, the
only sane way to do it is to let libsmbios handle it.  Moving the
fairly large and complex libsmbios into the kernel isn't a good idea
(imho).



-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
