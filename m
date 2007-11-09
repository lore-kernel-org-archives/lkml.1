Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbXKIMNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbXKIMNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXKIMM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:12:59 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:32806 "EHLO
	outbound9-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398AbXKIMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:12:57 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Fri, 9 Nov 2007 13:10:52 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "SANGOI DINO LEONARDO" <dino.leonardo.sangoi@allianz.it>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Len Brown" <len.brown@intel.com>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc1 and 2.6.24.rc2 hangs while running udev on my
 laptop
Message-ID: <20071109121052.GA30799@alberich.amd.com>
References: <2C8305E0BE090E47A2BAD52A48AC911D17BCE242@exchange1.lloyd.com>
 <20071109020321.b26b293f.akpm@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20071109020321.b26b293f.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Nov 2007 12:10:34.0078 (UTC)
 FILETIME=[87B77FE0:01C822C9]
X-WSS-ID: 6B2A91B707S1989573-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Nov 2007 09:47:02 +0100  SANGOI DINO LEONARDO <dino.leonardo.sangoi@allianz.it> wrote:
> > Hi,
> >  
> > My laptop (an HP nx6125) doesn't boot with kernels 2.6.24-rc1 and
> > 2.6.24.rc2. 
> > It works fine with 2.6.23 and older.
> > 
> > I seen this bug first while running fedora rawhide, so you can find hardware
> > 
> > info and boot logs at https://bugzilla.redhat.com/show_bug.cgi?id=312201.
> > 
> > I did a git bisect, and got this:
> > 
> > $ git bisect bad
> > 4f86d3a8e297205780cca027e974fd5f81064780 is first bad commit
> > commit 4f86d3a8e297205780cca027e974fd5f81064780
> > Author: Len Brown <len.brown@intel.com>
> > Date:   Wed Oct 3 18:58:00 2007 -0400
> > 
> >     cpuidle: consolidate 2.6.22 cpuidle branch into one patch

    ... snip ...

> > Config is taken from Fedora kernel. CONFIG_CPU_IDLE is set to y (tell me if
> > full config is needed).
> > 
> > If I use 'nolapic' parameter, kernel 2.6.24-rc1 boots fine. 
> > Setting CONFIG_CPU_IDLE=n also gives me a working kernel.

I am just thinking aloud ...

Boot log in the bugzilla shows:

  CPU0: AMD Turion(tm) 64 Mobile ML-34 stepping 02

So it seems that the hardware just dislikes CONFIG_CPU_IDLE.

I haven't dealt with that cpuidle stuff in the past.
Now I am wondering with which platforms that code was verified.
And yes, I know the code was in -mm for a while.
But maybe the test coverage on AMD platforms was not that high?

What about making CONFIG_CPU_IDLE dependent on EXPERIMENTAL for
the time being and remove EXPERIMENTAL when some more testing has
been done?


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



