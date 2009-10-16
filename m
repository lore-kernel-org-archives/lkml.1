Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZJPUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZJPUqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 16:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZJPUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 16:46:43 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:57812 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZJPUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 16:46:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Regression] - 2.6.32-rc5 hangs using rfkill on an eeePC
Date: Fri, 16 Oct 2009 22:46:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-wireless@vger.kernel.org
References: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com>
In-reply-To: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910162246.45678.elendil@planet.nl>
X-OriginalArrivalTime: 16 Oct 2009 20:46:46.0338 (UTC) FILETIME=[C6AC9220:01CA4EA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Comolli wrote:
> Pressing rfkill button on my eeePC 900 to disable wireless hangs the
> system.
> 
> In console I can see (warning: what follows is copied by hand):
> 
> acpid: client 148[6:100] has disconnected
> ACPI group/action not found: hotkey / ATKD
> unregister netdevice: waiting for wlan0 to become free; usage count=1
> (last line repeats forever). Hard reset is needed.
>
> With any previous kernel version (I'm running -rc4 right now) everything
> works:
>
> ACPI group/action undefined: hotkey / ATKD
> ath5k 0000:01:00.0: PCI INT A disabled

AFAICT there are only two commits since -rc4 that are likely candidates:

commit b56ab33d68638e6aafdbfc694025e8354a628f49
Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date:   Tue Oct 13 00:13:33 2009 +0200
    eeepc-laptop: Prevent a panic when disabling RT2860 wireless when
		  associated

commit 0af49167b1e5ba154e90d2c454bf4624ee47df80
Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date:   Wed Oct 14 02:19:22 2009 +0100
    Staging: rt2860sta: prevent a panic when disabling when associated

They look related and which one is relevant for you probably depends on 
which driver you're using.

Could you try reverting them both to see if that solves the problem?

Cheers,
FJP
