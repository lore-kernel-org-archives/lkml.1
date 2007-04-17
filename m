Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXDQTxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXDQTxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161115AbXDQTxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:53:09 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:34226 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161105AbXDQTxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:53:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WGKatOIjCYyM4wCAFjmoRhx0A834rPPM0ultSILCAR4q1yavZ6hc883rDw9QSf8iyPn1g2B7JDoC0dePFqHcJ3gL8E9ThuDOcYoyrpHsB6BD7NqA7mNgRDD55Pvy6YdkW8hXpV1lCNyUwVlVCi31MqdZHcUgJLi2EUfg330fJ3c=  ;
X-YMail-OSG: VF57SlkVM1kJI20Oi3.ZIbiOgTAPnCaj1ktqiKm5qQ3ireAI.zH56Jd8d6hr7pLROQ1vEo.lLA--
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Tue, 17 Apr 2007 12:53:02 -0700
User-Agent: KMail/1.7.1
Cc: Greg KH <greg@kroah.com>, Zhang Rui <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704031741.42273.david-b@pacbell.net> <200704071308.07571.david-b@pacbell.net> <20070413155949.GA9157@ucw.cz>
In-Reply-To: <20070413155949.GA9157@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171253.02748.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 8:59 am, Pavel Machek wrote:
> Hi!
> 
> > > Are you _sure_ you have a 1-to-1 relationship here?  No multiple devices
> > > pointing to the same acpi node?  Or the other way around?  If so, you
> > > are going to have to change the name to be something more unique.
> > 
> > I've wondered that too.  The short answer:  APCI only supports 1-1
> > here.  It will emit warnings if it tries to bind more than one ACPI

(Clarifying:  the ACPI *code* works that way.  I have no idea whether
ACPI itself makes such restrictions.  And I suspect that ACPI practice
will in some cases couple multiple ACPI devices to one PCI device...)


> ...
> > Assuming they all adopt that same "parallel tree" model, that seems
> > like a good idea.  The tools will likely need to understand how ACPI
> > and OF differ, but there's no point in reserving more names than we
> > really need.  Though it may be that "parallel trees" should go away.
> 
> If mapping is indeed 1-to-1 in acpi... it would be nice to just merge
> the trees.

Could you elaborate a bit ... what do you mean by "merge"?

One way to merge the trees would be to relocate

	/sys/devices/pci* --> ... this *HAS* a PNP node
	/sys/devices/pnp*/X --> /sys/devices/acpi_system*/.../X

Not having the PCI root be its PNPACPI node seems more buglike
to me than anything else.  And for other nodes, it seems like
maybe there should be a "firmware" subdirectory holding the
ACPI state (hid, path, etc) ... creating a minor chicken/egg
problem that ACPI would need to sort out.  Likely one can just
assume PCI and PNP busses exist, so creating nodes on those
buses based on ACPI tables would not be a problem.  And for
ACPI-internal devices, like SLPB and power buttons, the ACPI
bus would suffice.  But are there other busses?

- Dave
