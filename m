Return-Path: <linux-kernel-owner+w=401wt.eu-S1762552AbXFARY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762552AbXFARY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbXFARYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:24:05 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:45061 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757698AbXFARYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:24:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oG3IHwrHeMq7XyiqBVCVD1i6EnGCU475lvZNHpeig+kRBNLtyQ0IqhmlXJ+dlGvjQ66PwtigtVOSDNwyqFOLzKwcjndpBB9gF69AbdAsF+m8MiS/K9IVmhigi98KFisYBe+JNSVM0m36fqLiFYZ13xSdzjkFHxh+twaPyVmdQuw=  ;
X-YMail-OSG: e1k2HPYVM1mmh9PqkCffuBH8.7ZkVTq9MeLAP4I14j6YoKlvbupQQ0i0Qf9N0w9.dVxV3YjzOg--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Date: Fri, 1 Jun 2007 10:11:44 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <20070601074606.GA6060@dose.home.local> <20070601125422.GA12204@srcf.ucam.org>
In-Reply-To: <20070601125422.GA12204@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011011.44607.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007, Matthew Garrett wrote:

> The code for checking for a platform device only gets included if 
> CONFIG_PNP isn't set! David, surely this should be a runtime thing 
> rather than a compile-time one? Right now building a kernel with PNP 
> support will break horribly if it's then run on a non-PNP system...

Maybe it should be a runtime thing.  But then, on x86 there's
nothing to create the platform device for this driver either...

I had posted code to create that platform device at one point,
adjacent to what creates the pcspeaker device, but after ACPI
changed to require PNPACPI it wasn't needed on any system I
could test with.  There are probably a bunch of platform_device
nodes that should be created automagically on old PNP-less PCs.

- Dave
