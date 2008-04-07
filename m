Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYDGONn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYDGONn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 10:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYDGONe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 10:13:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:38189 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYDGONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 10:13:33 -0400
From: nikosapi <me@nikosapi.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend on Lenovo 3000 V200 - Linux 2.6.25rc8
Date: Mon, 7 Apr 2008 10:13:42 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <3e8fd0440804052010xbe8f59bw3268d8206b97ac3e@mail.gmail.com> <200804061930.49659.me@nikosapi.org> <200804071044.30445.rjw@sisk.pl>
In-Reply-To: <200804071044.30445.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071013.43083.me@nikosapi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On April 7, 2008 04:44:29 Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, nikosapi wrote:
> > On April 6, 2008 19:23:36 Rafael J. Wysocki wrote:
> > > On Monday, 7 of April 2008, nikosapi wrote:
> > > > On April 6, 2008 16:21:57 Rafael J. Wysocki wrote:
> > > > > On Sunday, 6 of April 2008, Nick Nobody wrote:
> > > > > > Hello,
> > > > >
> > > > > Hi,
> > > > >
> > > > > > I'm trying to get suspend working properly on my Lenovo 3000
> > > > > > V200. I'm using Linux 2.6.25rc8 and the latest xf86-video-intel.
> > > > > > Before I was using kernel-2.6.23.15-137.fc8,
> > > > > > xorg-x11-drv-i810-2.1.1-8.fc8 and suspend worked perfectly.
> > > > > >
> > > > > > The laptop will go to sleep properly but it doesn't seem to enjoy
> > > > > > waking up. When it starts up it will either display a black
> > > > > > screen and remain frozen or I will end up at a virtual term login
> > > > > > prompt but when I put in my username it never prompts me for my
> > > > > > password.
> > > > > >
> > > > > > The only way to get suspend working reasonably well is to first
> > > > > > hibernate and then suspend. After a hibernation suspend seems to
> > > > > > work fine :S
> > > > > >
> > > > > > I'm a real noob when it comes to figuring out these sort of
> > > > > > things, so any pointers on things I could try would be much
> > > > > > appreciated.
> > > > > >
> > > > > > Here's what s2ram has to say about my hardware:
> > > > > > Machine is unknown.
> > > > > > This machine can be identified by:
> > > > > >     sys_vendor   = "LENOVO"
> > > > > >     sys_product  = "07642CU"
> > > > > >     sys_version  = "LENOVO3000 V200"
> > > > > >     bios_version = "65ET32WW (1.06 )"
> > > > > >
> > > > > > Here's the output of dmidecode: http://pastebin.ca/973442
> > > > >
> > > > > Can you try to run "echo mem > /sys/power/state" instead of s2ram
> > > > > and see if the symptoms are the same?
> > > > >
> > > > > Also, please try reverting commit
> > > > > 7c0ea45be4f114d85ee35caeead8e1660699c46f (reproduced below for
> > > > > conveninence) and see if that helps.
> > > > >
> > > > > Thanks,
> > > > > Rafael
> > > > >
> > > > > ---
> > > > > commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
> > > > > Author: Zhao Yakui <yakui.zhao@intel.com>
> > > > > Date:   Tue Mar 11 16:56:47 2008 +0800
> > > > >
> > > > >     ACPI: Ignore _BQC object when registering backlight device
> > > > >
> > > > >     According to acpi spec , the objects of  _BCL and _BCM are
> > > > > required if integrated LCD is present and supports brightness level
> > > > > .The _BQC is the optional object. So the _BQC object is ignored
> > > > > when the backlight device is registered in ACPI video driver.
> > > > >
> > > > >     http://bugzilla.kernel.org/show_bug.cgi?id=10206
> > > > >
> > > > >     Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
> > > > >     Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
> > > > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > > > >
> > > > > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > > > > index 12cce69..ace958c 100644
> > > > > --- a/drivers/acpi/video.c
> > > > > +++ b/drivers/acpi/video.c
> > > > > @@ -713,7 +713,7 @@ static void acpi_video_device_find_cap(struct
> > > > > acpi_video_device *device)
> > > > >
> > > > >  	kfree(obj);
> > > > >
> > > > > -	if (device->cap._BCL && device->cap._BCM && device->cap._BQC &&
> > > > > max_level
> > > > >
> > > > > > 0){ +	if (device->cap._BCL && device->cap._BCM && max_level > 0)
> > > > > > {
> > > > >
> > > > >  		int result;
> > > > >  		static int count = 0;
> > > > >  		char *name;
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > linux-acpi" in the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > > > Hello Rafael,
> > > >
> > > > I tested with that patch and the problem persists, when the laptop
> > > > resumes it locks up (with a black screen). If I add
> > > > acpi_apic_instance=2 acpi_osi=Linux as kernel boot options (as
> > > > suggested by my dmesg) when it resumes I get back to a virtual term
> > > > but I'm not able to log in. After entering my username it just hangs
> > > > there.
> > >
> > > Can you please test if the 2.6.24.4 kernel works, then?
> > >
> > > Rafael
> > > --
> >
> > What a coincidence, I upgraded to kernel-2.6.24.4-64.fc8 this afternoon.
> > Suspend and hibernate work perfectly, even my wifi led works ;)
> >
> > Could it be an error I made while configuring the 2.6.25rc8 kernel? Or
> > maybe some other software that needs to be upgraded?
>
> Most probably, there's a regression in the kernel.
>
> Since the issue seems to be 100% reproducible for you, could you please
> carry out a bisection to find the commit that broke things for you?
>
> Rafael
> --

Hello,

I've never done a bisection before, I found this[1] page that seems to explain 
the procedure. At the moment I don't have too much free time to try that out, 
I can get back to you at the end of the week.

Thanks,

nick

[1] http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
