Return-Path: <linux-kernel-owner+w=401wt.eu-S1750847AbXBMTnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750847AbXBMTnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXBMTnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:43:37 -0500
Received: from smtp.cce.hp.com ([161.114.21.23]:18020 "EHLO
	ccerelrim02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXBMTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:43:36 -0500
X-Greylist: delayed 5946 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 14:43:36 EST
Message-ID: <45D214E4.9020608@hp.com>
Date: Tue, 13 Feb 2007 14:43:32 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Hasso Tepper <hasso@estpak.ee>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: /proc/sys/net/ipv[46]/conf/ issue unsolved
References: <200702131529.04708.hasso@estpak.ee> <20070213185820.GB25362@hmsreliant.homelinux.net>
In-Reply-To: <20070213185820.GB25362@hmsreliant.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.0.289146, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.13.113434
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Tue, Feb 13, 2007 at 03:29:04PM +0200, Hasso Tepper wrote:
>> There is long standing issue in kernel which makes using /etc/sysctl.conf
>> useless for boottime configuration of specific interface properties and
>> breaks probably any software relying on unconditional existence of the
>> conf trees like it was in previous kernels (I alone have written several
>> pieces of such software). It's broken AFAIK from 2.6.15. There has been
>> several notes about issue in the list, but issue haven't got any (at least
>> efficient) attention from developers.
>>
>> The current behaviour bites users in many ways and breaks several use cases.
>> I asked several times in the past "what I should do now?" question, but
>> got no clear answer.
>>
>> References:
>> http://marc.theaimsgroup.com/?l=linux-netdev&m=115685059625467&w=2
>> http://marc.theaimsgroup.com/?l=linux-netdev&m=115690828822486&w=2
>> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=169809
>>
>> Is there any chance this will be fixed or at least clear position is
>> taken by developers? Breaking userspace applications is declared nonono
>> several times in the past ... I'm not even against breaking it if there
>> is _very_ good reason to do it. Ok, but I want to know how userspace is
>> meant to behave now. I can't continue using crappy workarounds.
>>
> Can't this simply be fixed by adding a custom udev rule?  Correct me if I'm
> wrong, but the only reason that interfaces come up automatically after their
> appropriate module is inserted is because most distos udev rules issue an ifup
> $DEVICE when they get a creation event for $DEVICE.  Why not add a custom rule
> in for net device creation events to set appropriate sysctl values before the
> ifup is issued.
> 

You can't.  The /proc/sys/conf/eth<x>/  structure appears when the 
interface is marked UP.  At this point, if protocol modules are already
loaded, your configuration parameters are already set.

I was going to ask.. How are you testing Optimistic DAD patch.  The
only way I could do it was to set /proc/sys/conf/default/ipv6  entry.

-vlad
