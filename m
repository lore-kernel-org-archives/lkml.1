Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYA0Us4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYA0Us4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 15:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYA0Usp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 15:48:45 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21847 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbYA0Uso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 15:48:44 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JVBL8D-01-2NH-01
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Sun, 27 Jan 2008 13:38:26 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andrew Paprocki" <andrew@ishiboo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: lxfb is not changing modes, no errors/information printing
 out
Message-ID: <20080127203826.GA9612@cosmic.amd.com>
References: <76366b180801271045u7342540p58f5970a49c097be@mail.gmail.com>
 <20080127192807.GF8635@cosmic.amd.com>
 <76366b180801271155y36feaf51g3a22cd34b9a6c4a0@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <76366b180801271155y36feaf51g3a22cd34b9a6c4a0@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 27 Jan 2008 20:36:17.0746 (UTC)
 FILETIME=[44960B20:01C86124]
X-WSS-ID: 6B8234CB24S9230230-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/08 14:55 -0500, Andrew Paprocki wrote:
> On Jan 27, 2008 2:28 PM, Jordan Crouse <jordan.crouse@amd.com> wrote:
> > On 27/01/08 13:45 -0500, Andrew Paprocki wrote:
> > > Using 2.6.24, I can't get my Geode LX (LX800 CPU) to boot in anything
> > > other than the default 80x25 console even though lxfb appears to be
> > > loading normally. This device doesn't work with the VESA fb either
> > > when I request "vga=0x31a". All the other boards I have display a
> > > 1280x1024 console on my monitor. Are my kernel parameters wrong in
> > > some way? I tried "video=lxfb:<mode>" with and without "vga=0x31a".
> > > The driver is compiled into the kernel -- I am not using modules.
> >
> > Can you change the mode after you have booted with 'fbset'?
> 
> Two answers to this I just found out..
> 
> This is a system I installed BusyBox 1.8.0 on, and running 'fbset
> 1280x1024-75' does nothing. I copied over the real fbset binary from
> my Debian install and when I ran it the same way, it worked perfectly.
> So, yes, it appears that it is possible to change it after the fact,
> but for some reason BusyBox can't do it. The only problem then appears
> to be setting the fb mode from the boot line.

The busybox binary does have differences - I think that the -n parameter
is required to set the mode 'right now'.  But I'm glad that the
mode change works (thats the tough part).  Probably something changed
in the way we handle the setup and/or the mode database, thats easy enough
to instrument and fix.  I'll check this out tomorrow, and do a patch for
the blanking bug too.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


