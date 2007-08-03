Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbXHCGBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbXHCGBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXHCGBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:01:12 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:22997 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753378AbXHCGBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:01:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Hh/1ST3pjUY2bw7ssrc/VLDX5Q3g3yiCCYU17I8vtwjICwPn1M9AfB/9LQmxmn5Sz26LgZQUGKPuvA7jrYBnKy9dUQC9LvrAMIxcjesuC7/OM7KZgj31f74EM1mEBIfpVji/tD6pMV8HatfoSe2M2czEO3PGR6YTUyFfvRLFTHo=  ;
X-YMail-OSG: dKnHl4gVM1mSnhfgi_f4VbJD0RkCfnbAWLNdWnGnHkdULbYHNKZZdXrCv0Y_s.rIWAQqIM3lXMw1SYJLEKUnYgDAfhG.Pe8hnIaMFEyDGzouAQ4pgkftBuVKiBGAiePbjNn7Haq2PMdZGKI-
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Thu, 2 Aug 2007 23:01:08 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708022301.08719.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007, Alan Stern wrote:
> Also, building something this sweeping into a kernel driver feels like
> a mistake.  It ought to be more easily configurable from userspace, say
> via a sysfs file.

Yeah, I could have sworn there was extensive discussion over the
creation of a sysfs .../power/autususpend attribute which can enable
or disable autosuspend on a per-device basis. 

Seems to me it ought to be practical to organize a database that can
be consulted by an outcall from udev, disabling autosuspend on devices
which are known to be broken.  The "modules.usbmap" syntax is an obvious
place to start (painful though it is), and I'm sure there are folk who
would prefer web-accessible/updatable databases.

It'd need people to maintain that, of course, along with whatever
tools consult it.  But that's a solvable problem, and it would keep
the problem properly outside of the kernel.

Long term, of course, this is just a pile of bugs for device vendors
to fix in their next revisions ... so they don't end up on the list
of "devices to avoid buying" for use with Linux systems.

- Dave

