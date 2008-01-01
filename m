Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYAARdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYAARdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYAARd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:33:26 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:58762 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYAARdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:33:25 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185ywZ1tFDD9RObnvxjzGoV
Message-ID: <477A7941.8080603@reed.com>
Date: Tue, 01 Jan 2008 12:32:49 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu>
In-Reply-To: <20080101161557.3ce2d5f8@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox wrote:
> That does imply some muppet 'extended' the debug interface for power
> management on your laptop. Also pretty much proves that for such systems
> we do have to move from port 0x80 to another delay approach.
>   
Alan - in googling around the net yesterday looking for SuperIO chipsets 
that claim to support port 80, I have found that "blade" servers from 
companies like IBM and HP *claim* to have a system for monitoring port 
80 diagnostic codes and sending them to the "drawer" management 
processor through a management backplane.   This is a little puzzling, 
because you'd think they would have noticed port 80 issues, since they 
run Linux in their systems.  Maybe not hangs, but it seems unhelpful to 
have a lot of noise spewing over a bus that is supposed to provide 
"management" diagnostics.  Anyway, what I did not find was whether there 
was a particular chipset that provided that port 80 feature on those 
machines.  However, if it's a common "cell" in a design, it may have 
leaked into the notebook market chipsets too.

Anyone know if the Linux kernels used on blade servers have been patched 
to not do the port 80 things?  I don't think this would break anything 
there, but it might have been a helpful patch for their purposes.  I 
don't do blades personally or at work (I focus on mobile devices these 
days, and my personal servers are discrete), so I have no knowledge.

It could be that the blade servers have BIOSes that don't do POST codes 
over port 80, but send them directly to the "drawer" management bus, of 
course.  
