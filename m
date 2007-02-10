Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbXBJGnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbXBJGnn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 01:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXBJGnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 01:43:43 -0500
Received: from 1wt.eu ([62.212.114.60]:2304 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbXBJGnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 01:43:42 -0500
Date: Sat, 10 Feb 2007 07:43:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jeff Garzik <jeff@garzik.org>
Cc: nigel@nigel.suspend2.net, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070210064319.GJ24090@1wt.eu>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171059968.1484.90.camel@nigel.suspend2.net> <45CD10FE.3050506@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CD10FE.3050506@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 07:25:34PM -0500, Jeff Garzik wrote:
> Nigel Cunningham wrote:
> >Hi.
> >
> >On Fri, 2007-02-09 at 23:17 +0100, Arjan van de Ven wrote:
> >>On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
> >>>Hi.
> >>>
> >>>I don't think this is already done (feel free to correct me if I'm
> >>>wrong)..
> >>>
> >>>Can we start to NAK new drivers that don't have proper power management
> >>>implemented? There really is no excuse for writing a new driver and not
> >>>putting .suspend and .resume methods in anymore, is there?
> >>
> >>to a large degree, a device driver that doesn't suspend is better than
> >>no device driver at all, right?
> >
> >I'm not sure it is. It only makes more work for everyone else: We have
> >to help people figure out what causes their computer to fail to resume
> >(which can take quite a while), then get them them complain to driver
> >author, and the driver author has to submit patches to fix it.
> >
> >All of this is avoided if they'll just do it right in the first place.
> 
> A lot of a lot of things could have been avoided, if they just did it 
> right the first time.
> 
> I think it's more valuable to users to get a basic network driver that 
> pings or a basic ATA driver that reads/writes, than peripheral issues 
> like suspend/resume.

100% agreed.

I've been used to a notebook (VAIO) which did not correctly shut down, and
did not support reboot. Now the one I have behaves normally on both features.
I've never ever felt the need for suspend/resume, that I've always attributed
to "geeks" requirements. I had to debug the shutdown code myself for the
previous notebook, and discovered that it was caused by bugs in the ACPI
state transitions for suspend and such fancy features. I would really have
prefered that the people writing the ACPI code had focused first on power-on/
power-off before the rest.

> Certainly we should ask for it, but it shouldn't be a merge-stopper.

I think we should even proceed in the opposite direction : refuse to suspend
if at least one driver does not support the feature, and enumerate the
faulty drivers on the console. While I agree that a machine which resumes
in a bad state is not funny at all to debug, at least when the user expects
his notebook to suspend and sees that it refuses, he can complain about the
drivers which do not support it, and can even unload them first if unneeded.

Regards,
Willy

