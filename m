Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbXE1CGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbXE1CGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXE1CGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:06:33 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:46421 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751325AbXE1CGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:06:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HmyHaGRIo4I7Yd4XYVRPdpM9wBsiM2MGEyhYmmUWyQXh/PjWdYdzZa6fB0Zu3M/pW6WGwjYVrY2pfxSZiUgnbrG498chcHjbs5ag2/xyxrZOz3JGQR4fG1DuAJ86He0GzOmE2RcrGAuQGRmG9HGEa060uFBNadcmFgpCG+nk6Mg=  ;
X-YMail-OSG: 93Dpmd0VM1kj759oKCNQWB9JqbjyYuU.KJF4Lw9sWl6hGT0M
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Date: Sun, 27 May 2007 18:36:51 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070527190351.GA21387@srcf.ucam.org>
In-Reply-To: <20070527190351.GA21387@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271836.55800.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007, Matthew Garrett wrote:
> f5f72b46c349fefcfd4421b2213c6ffb324c5e56 appears to break the userspace 
> interface to the CMOS alarm. This could previously be accessed via 
> /proc/acpi/alarm ...

I was a bit surprised the ACPI team didn't have more comments on
that issue, myself.  Thing is, all of /proc/acpi/* is deprecated
(scheduled for removal in barely over one month!) and nobody had
found any actual users of that "alarm" file when they searched for
them a while ago.  I suppose the conclusion then was that there
are no applications using it.


> I'm not actually sure why this is the case. It doesn't look like the two 
> interfaces are fundamentally incompatible.

ISTR the issue is that ACPI only allows one chunk of code to hook
into the relevant notifications.  So:  either /proc/acpi/wakeup;
or /sys/class/rtc/rtc0/wakealarm; but not both.


> I agree that removing the  
> proc code is a good long-term aim, but it'd be nice to be able to test 
> the new RTC code without removing existing functionality.

Coexistence is unfortunately problematic here.  And with "long term"
documented to be a bit over a month ... I guess all I can say is
that if you can come up with a good patch to make both available,
please do so.

- Dave
