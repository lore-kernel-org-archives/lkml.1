Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYAYPBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYAYPBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYAYPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:01:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbYAYPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:01:30 -0500
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
Date: Fri, 25 Jan 2008 16:01:28 +0100
In-Reply-To: <alpine.LSU.0.999.0801251551060.21522@be1.lrz> (Bodo Eggert's message of "Fri\, 25 Jan 2008 15\:54\:42 +0100 \(CET\)")
Message-ID: <p73ejc67xvb.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> Enabling this option changes a hard panic on boot errors to a
> soft panic, which does not stop the system completely.
> You can still scroll the screen and read the messages.

I don't think it's a good idea to keep the network running in the
soft panic. A lot of people have set ups that use ping was a watchdog
and with nfsroot/ip=dhcp ping does work quite well before
mounting root and then the watchdog might not pick up the 
soft panic.

Using a polled keyboard driver after panic seems to be the better
option to me, but if you want softpanic you should probably
at least add a suitable panic notifier to the network stack 
to shut it all down.

-Andi
