Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbXF1Mmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbXF1Mmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbXF1Mmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:42:46 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50835 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXF1Mmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:42:46 -0400
Message-ID: <4683ABE7.3020109@gmail.com>
Date: Thu, 28 Jun 2007 14:39:03 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Patrick Draper <pdraper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com> <468315AF.1080105@gmail.com> <4683252B.9010205@gmail.com>
In-Reply-To: <4683252B.9010205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 05:04 AM, Patrick Draper wrote:

> Rene Herman wrote:

>> So -- the fact that mixing actually works for you when using libaoss 
>> means software mixing is working correctly for your ALSA setup. The 
>> only thing you should do is _use_ ALSA (natively) and not its OSS 
>> emulation so you can drop the library preload.
> 
> Cool. How do I go about figuring out what every app uses? For example, 
> you mentioned that the flash 9 plugin, which I also use, is an ALSA 
> aware application. How do you know?

Various methods. If all's well, the application has a config menu where you 
can look at and change the settings.

Or, running ldd on the binary to see if it's linked to libasound, "grep 
/proc/<pid>/maps libasound" (also catches dlopen), "strace" or usually 
easiest and what I tended to do -- "lsmod" to see if starting the app 
triggered the automatic loading of snd-pcm-oss and snd-mixer-oss which I 
don't normally have loaded.

This is the "[things are still not great] partly _due_ to people maintaining 
OSS is somehow a valid choice on Linux" that I stated early in this thread. 
I actually believe the kernel space OSS emulation has been fairly counter 
productive -- it's allowed applications to stay with an obsolete interface 
since the users didn't even have to _know_ due to it all just working. At 
least with the userspace emulation, people know they are using an OSS 
emulation if they are starting the application with an library preload.

The kernel space emulation is a bit more bullet-proof in the sense that the 
userspace emulation would not for example help with applications that use 
direct syscalls to open device nodes and I guess that was important.

When OSS/Free was replaced with ALSA inside the Linux kernel this was a big 
change in an area most users use and any such change inevitably opens up big 
cans of change resistant wankers who understand the old interface and have 
no need for the new one and will tell you that you did it all wrong, it was 
all for nothing and you suck period. They'll keep it up for years and years 
generally. The kernel-space OSS emulation _does_ mostly just work, which is 
the kind of thing that you need in this environment to be allowed to tell 
these people to go sexually entertain themselves.

Perhaps it's now finally coming to the time where the kernel space emulation 
can be deprecated and eventually removed. Or not...

> I need the check out everything that I use which needs sound (vmware,
> skype, kmplayer, etc.) I don't have source code for at least two of
> those.

I don't know if vmware by now supports native ALSA but it didn't use to. The 
current version of skype (1.4, still called a beta it seems) does.

kmplayer seems to be a frontend for various mediaplayer solutions. Don't you 
just love that mess? Its backends include MPlayer and Xine, and both these 
can talk native ALSA fine at least. For mplayer, use a "ao=alsa" line in the 
.mplayer/config file (or just start it with -ao alsa) and for xine, look in 
its setup menu (audio tab, having set the interface level to beter than 
"beginner").

Rene.

