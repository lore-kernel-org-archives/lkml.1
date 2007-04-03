Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXDCRx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXDCRx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161048AbXDCRx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:53:56 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:53552 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161039AbXDCRxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:53:55 -0400
Message-ID: <461294B0.5010303@nagafix.co.uk>
Date: Tue, 03 Apr 2007 18:53:52 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Blaisorblade <blaisorblade@yahoo.it>
CC: Jeff Dike <jdike@addtoit.com>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
References: <1712880100@web.de> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <200704031943.15001.blaisorblade@yahoo.it>
In-Reply-To: <200704031943.15001.blaisorblade@yahoo.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Blaisorblade wrote:
> On lunedì 2 aprile 2007, Antoine Martin wrote:
>> Jeff Dike wrote:
>>> On Sun, Apr 01, 2007 at 08:58:45PM +0100, Antoine Martin wrote:
>>>> I reckon that one critical thing which could drastically increase the
>>>> user base would be to have a working virtual framebuffer implementation.
>>> Why?  I've never understood what a framebuffer gives you that you
>>> don't have now.
>> Just like the network auto-configuration via dhcp,
> Hmm... for that to be completely plug-and-play you need to make sure a dhcp 
> server on the host exists.
> 
> Vmware runs a separate DHCP server exactly for this, even if we should avoid 
> that as much as possible.
It is trivial to write a shell script that takes care of setting up the 
interface and checks for the presence of a dhcp server. (the dhcpd.conf 
can be generated easily)

The problem lies with the configuration options, I have got a bunch of 
shell scripts to take care of that, but it is quite hard to make them 
suitable for global consumption by the average user:
* even with just tap networking, I use 4 different ways of hooking them 
up the outside world
* firewalling and mac address filtering
* bridging issues and ebtables
* tmpfs and memory issues
* selinux and chrooting issues...
etc...

[snip]
> although it stopped working for me ages ago (probably for some UML bug). I 
> built a Mandrake image (that I now lost) with Xnest configured. With a script 
> on the host which passes the host IP and that calls xhost, it should work 
> easily. And btw, we need a standard startup script anyway.
It would work, but it's not a pretty solution, it requires 
customizations to the guest and it would not be intuitive to new users.
I would much prefer the ability to just run any distro (even framebuffer 
based ones) without modifications using the virtual framebuffer.

>> It would also make it a lot easier to focus on writing a management UI,
>> hell if there isn't one shortly after, I'll do one myself!
> 
> Why not one management UI running from the host, a-la vmware?
Yes ,that was what I had in mind.
> Possibly, with 
> as much code as possible in scripting languages, for better transparency.
Definitely, (see above)

The management tools I have written export the guests' settings to the 
filesystem in the form of a shell script file, all the utility scripts 
just read those settings and do their stuff. (all in simple shell)
Antoine


>> Think of a UML browser image (running IE via wine in a limited image
>> with just X + wine + IE - I would much prefer that to having wine+IE
>> installed locally), testing framebuffer apps like gtk-fb/cairo-fb
>> without risking your dev environment, etc...
>>
>> Antoine
> 
> 
> 

