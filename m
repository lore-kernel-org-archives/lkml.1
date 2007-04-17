Return-Path: <linux-kernel-owner+w=401wt.eu-S1161361AbXDQWAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161361AbXDQWAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031277AbXDQWAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:00:46 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:24365 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031272AbXDQWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:00:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=zZKba267wv0RctEd+O5j4C6mg2q6yuzJhWW+WWKI0NZZRpSdT4lT6ZK9Yn9Mc+gS3fa3L40sf9WwhkGV6vmFnQdhHfbvld4VVnheGvLe22hZd6c2T7D5MzWeczDCk7Ia+qt9cyus795pP4/CXFsC1c8Ao4RuVhLzNCwSQVQSTac=  ;
X-YMail-OSG: YIoNhlcVM1m7mqKuKj233ghvdK4Lr3oaqgkocA9Xim3Giyen43hWNbC7Q6nS36fGI3dULH9SLg--
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Tue, 17 Apr 2007 14:57:49 -0700
User-Agent: KMail/1.7.1
Cc: Greg KH <greg@kroah.com>, Zhang Rui <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704031741.42273.david-b@pacbell.net> <20070413155949.GA9157@ucw.cz> <200704171253.02748.david-b@pacbell.net>
In-Reply-To: <200704171253.02748.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704171457.50416.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 12:53 pm, David Brownell wrote:
> On Friday 13 April 2007 8:59 am, Pavel Machek wrote:
> 
> > ...
> > > Assuming they all adopt that same "parallel tree" model, that seems
> > > like a good idea.  The tools will likely need to understand how ACPI
> > > and OF differ, but there's no point in reserving more names than we
> > > really need.  Though it may be that "parallel trees" should go away.
> > 
> > If mapping is indeed 1-to-1 in acpi... it would be nice to just merge
> > the trees.
> 
> Could you elaborate a bit ... what do you mean by "merge"?
> 
> One way to merge the trees would be to relocate
> 
> 	/sys/devices/pci* --> ... this *HAS* a PNP node
> 	/sys/devices/pnp*/X --> /sys/devices/acpi_system*/.../X
> 
> Not having the PCI root be its PNPACPI node seems more buglike
> to me than anything else.  And for other nodes...

Looks like the i8042 serial nodes will be bizarre too:

	/sys/devices/pnp0/00:09
		... touchpad's PNP node
	/sys/devices/acpi_system:00/device:00/PNP0A03:00/device:15/PNP0F13:00
		... its ACPI node
	/sys/devices/platform/i8042/serio4
		... its serio node

That seems like two nodes too many, but without me trying to twist
my mind around i8042 issues, I can't quite speculate why struct
serio "is-a" device rather than "has-a" device (the PNP node) as
would be the case with a more normal driver structure.

But the existence of that device_add() in serio.c sure explains why
the PNP node doesn't get associated with the input class device one
would expect from knowing that 00:09 is the touchpad.

And hmm, just this morning I saw email from Greg re-affirming that
drivers should not device_add().  Converting such legacy drivers is
simple though, right?  :)

- Dave

