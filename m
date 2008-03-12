Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYCLTgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYCLTgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYCLTgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:36:47 -0400
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:41372 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751701AbYCLTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:36:46 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Wed, 12 Mar 2008 12:36:43 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <47D828BB.2000702@gawab.com>
In-Reply-To: <47D828BB.2000702@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121236.43267.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 12, 2008 12:02 pm Justin Madru wrote:
> Hi,
>
> I'm not sure, but I think I've found a regression in the latest development
> kernel (2.6.25-rc5). The problems don't happen when using the distro's
> 2.6.22 kernel (ubuntu 7.10), or when I was testing 2.6.23 and 2.6.24.
>
> These are the problems I've been having:
>
> 1) Blank screen: Upon entering graphical mode the screen goes blank
> (black). It seems to happen when X is probing for the video modes. Pressing
> ctrl+alt+f1 doesn't do anything, except "refresh" a black screen. The
> computer still works, and I can log in from GDM, but I just can't see
> anything on the screen; I have to reboot.
> The work around is that when the boot splash screen (usplash) is about
> halfway loaded I switch to the first terminal, and everything is fine (or
> maybe that's just a coincidence).
>
> 2) Wireless errors: Upon connecting to a wireless router I get a flood of
> kernel messages that don't stop: "kernel: wlan0_rename: RX too short data
> frame payload".
> I do successfully connect. No workaround to stop the messages (while still
> having connection).
>
> 3) Flashing Red: When I shutdown, the screen flashes red several times
> before the shutdown splash screen shows up.
>
> #1 and #3 happen at random. Although, It seems to happen more on the first
> boot up. #2 consistently happens when connecting to my University's
> wireless; rarely (if ever) on my home router.
>
> Relevant sysinfo (Dell Inspiron E1505; Intel T2080 @ 1.73GHz):
> 0b:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network
> Connection (rev 02) 00:02.0 VGA compatible controller: Intel Corporation
> Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev
> 03) 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
> 943/940GML Express Integrated Graphics Controller (rev 03)
>
> Could this be a regression? What can I do to help identify the problem?
> I've tried to start analyzing the blank screen problem, so let's start
> there because I've already created a diff log report.
>
> For a diff of my system logs for the blank screen problem see (104.61 KB):
> http://jdserver.homelinux.org/linux/blank_screen_log_diff.txt

It's kind of hard to read the context diff (unified diffs are much nicer) but 
nothing jumps out at me regarding your video config.  Does the blank screen 
problem occur if you disable usplash altogether and compile out the fb 
drivers?  The intelfb driver in particular can cause problems sometimes since 
it supports so few configurations, you might try the vesafb driver too.

Jesse
