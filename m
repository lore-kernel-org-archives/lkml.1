Return-Path: <linux-kernel-owner+w=401wt.eu-S965175AbXCAQJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175AbXCAQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965315AbXCAQJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:09:56 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:53852 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965175AbXCAQJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:09:56 -0500
X-Greylist: delayed 1920 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 11:09:56 EST
Date: Thu, 1 Mar 2007 16:39:18 +0100
From: DervishD <udev@dervishd.net>
To: Udev/Hotplug <linux-hotplug-devel@lists.sourceforge.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: udev rule makes the system hang: revisited
Message-ID: <20070301153918.GA2420@DervishD>
Mail-Followup-To: Udev/Hotplug <linux-hotplug-devel@lists.sourceforge.net>,
	Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :))

    I'm CC'ing this message to LKML because I don't know if this is some
weird (and known) interaction between modules.

    I'm using vanilla 2.6.19.5.

    I was having a problem using this rule:

ACTION=="add", ENV{MODALIAS}=="?*", RUN+="/sbin/modprobe $env{MODALIAS}"

    and I finally found the module that was hanging the system:
something with alias "serio:alotofnumbersanddigits".

    I've replaced the rule above by this one:

ACTION=="add", ENV{MODALIAS}=="?*", ENV{MODALIAS}!="serio*",
    RUN+="/sbin/modprobe $env{MODALIAS}"

    But the question is: why?. And: who is causing the request?. As far
as I know, the only serio things I have are my keyboard and my PS/2
mouse connector (which *doesn't* have a mouse connected), and of course
my keyboard support is not a module (although psaux is).

    Anyone has any idea about what the problem may be? The aliases for
the modules when the event is handled by udev are those:

    serio:ty06pr00id00ex00
    serio:ty01pr00id00ex00

    If I filter out THOSE TWO aliases and only those, the system doesn't
hang. Otherwise, the system appears dead, not even sysrq works (I can't
check ping because right now there aren't other machines in the network,
so probably the machine is not *that* dead, and only the keyboard has
dead :??).

    Thanks a lot in advance. If anyone needs more information or tests,
just ask.

    Kay, I followed your advice, booted without udev and make some tests
until I found the culprit. Hard, but fruitful ;)) Thanks :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
