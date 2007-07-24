Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbXGXXan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbXGXXan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbXGXXae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:30:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:35533 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbXGXXac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KUiC1IRWkZPTrM+1QZYBvprGUtP7b0vDyzNBTslIluhwu5TgDPuzdExx2Ump7bmLh2rSEzhI5RY8ptsPzigoGQ3NXa/gJuLs/3YNna6z9KqwOH5xuDjwG/eX8Njoi3cUZ5f1vSI4aDGNtpN1ZJp20eMxB7+w8aqZKOixRUoTDJU=
Message-ID: <6bffcb0e0707241630p3599ad99sfd778097b307e78c@mail.gmail.com>
Date: Wed, 25 Jul 2007 01:30:31 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Florian Lohoff" <flo@rfc822.org>
Subject: Re: 2.6.23-rc1 sky2 boot crash in sky2_mac_intr
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070724094042.GA6414@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724082205.GA19480@paradigm.rfc822.org>
	 <20070724095008.0eb154fe@oldman.hamilton.local>
	 <20070724094042.GA6414@paradigm.rfc822.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On 24/07/07, Florian Lohoff <flo@rfc822.org> wrote:
> On Tue, Jul 24, 2007 at 09:50:08AM +0100, Stephen Hemminger wrote:
> > The problem is related to power management. The PHY has a number of PCI configuration
> > registers for power control, and the function of these changes based on the version and
> > revision of the chip. The driver does work on older versions of the EC-U, in
> > Fujitsu laptop's, it is just the new rev that is broken.
> >
> > The driver should probably fail smarter (by not loading) if the PHY isn't powered
> > up correctly, but that doesn't help your problem.
> >
> > The vendor has provided me with documentation on many versions
> > of the chip, but I don't have doc's on the lastest revision differences of the EC Ultra,
> > so a proper solution is not easily available.  The best method for resolving this would
> > be to first try the vendor driver version of sk98lin and see if that fixes it. If so,
> > then it is easy to change sky2, to match the phy setup in the vendor driver.
> > Another possibility is to look for places in sky2 driver where there are places
> > that compare version/revision.
> >
> > The most likely bits that need to change are in PCI registers: 0x80, 0x84 and 0x88
> > You could also load the windows driver and dump PCI config space (with lspci from
> > cygwin), and see what the settings are there.
> >
> > I am away from my office for a month, and therefore away from any sky2
> > hardware for testing.
>
> I'll try the above and keep you posted. The crash itself seems to be a
> 2.6.23-rc1 regression though. I never experienced this with 2.6.22-rc5
> which i was running before.

Can you try to figure out what is causing this crash and then use git-bisect?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
