Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYAFNPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYAFNPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYAFNPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:15:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46977 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYAFNPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:15:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780D3E5.20908@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 14:13:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist>
In-Reply-To: <20080106123728.GD2082@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 01:18:48PM +0100, Stefan Richter wrote:
>> I'm afraid this can't be put into practice.  (User says which hardware
>> and protocols he needs to be supported, scripts magically assemble a
>> suitable configuration.)
> 
> Distribution installers and live CDs like Knoppix even manage to 
> magically assemble a suitable configuration (e.g. autodetecting which 
> modules they should load) without asking the user any questions.

Module autoloading is quite different.

> The information the user has to give when configuring his kernel is 
> whether he wants to connects USB disks - whether or not the 
> implementation of the kernel driver uses the in-kernel SCSI layer we can 
> easily handle automatically without bothering the user.
> 
>> I think
>>   - sensibly modularize our software,
>>   - tell the user which software components there are,
>>   - what they are for,
>>   - how they depend on each other,
>>   - make it easy enough for the user to navigate in the dependency
>>     graph,
>>   - provide fundamental safeguards and checks for a proper software
>>     configuration
>> is the best we can do.
> 
> It sounds strange that what you call the "the best we can do" would be 
> much worse than what we are currently doing...
> 
> The current status quo is that a user e.g. only has to know that his 
> ethernet controller is a "Broadcom 440x/47xx", the fact that a Sonics 
> Silicon Backplane bus is used on the card is handled automatically by 
> kconfig.

if NET_ETHERNET
...
config B44
	tristate "Broadcom 440x/47xx ethernet support"
	depends on SSB_POSSIBLE
	select SSB
	select MII
...
endif # NET_ETHERNET

There is a B44 option.  The prompt string (in other cases the help text)
tells what it is for.  Furthermore, four dependencies are encoded; one
in the direct form, one by if/endif, two in reverse form.  There are no
further hints how to satisfy SSB_POSSIBLE, NET_ETHERNET, SSB, MII.  The
kconfig system is told to enable SSB and MII no matter what, as long as
SSB_POSSIBLE, NET_ETHERNET, and B44 are != n.

This /is/ what we are currently doing, not "worse than what we are
currently doing".  We
  - sensibly modularize our software,
  - tell the user which software components there are,
  - what they are for,
  - how they depend on each other,
  - make it easy enough for the user to navigate in the dependency
    graph,
  - provide fundamental safeguards and checks for a proper software
    configuration.  (Well, we actually walk on thin ice whenever we
    use the 'select' keyword.)

(Now, after the b44.ko has been built and installed, the object file
should contain aliases which let modern userland automatically load this
kernel object if respective hardware has been detected and the module
wasn't blacklisted.  So, run-time configuration is more comfortable than
build-time configuration, except that help texts aren't as easily
accessible at run-time as they are at build-time.)
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
