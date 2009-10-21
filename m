Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZJUGuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZJUGuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZJUGui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:50:38 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:56883 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZJUGui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:50:38 -0400
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Allow renaming of network interfaces that are up.
References: <87zl7rp1jy.fsf@spindle.srvr.nix> <1255723078.14249.16.camel@calx>
	<87k4yup9bd.fsf@spindle.srvr.nix> <87vdi9ew1h.fsf_-_@spindle.srvr.nix>
	<20091021103846.2f985ea1@s6510>
From: Nix <nix@esperi.org.uk>
Emacs: the definitive fritterware.
Date: Wed, 21 Oct 2009 07:50:30 +0100
In-Reply-To: <20091021103846.2f985ea1@s6510> (Stephen Hemminger's message of "Wed, 21 Oct 2009 10:38:46 +0900")
Message-ID: <874optb5qh.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc:s adjusted, thanks davem]

On 21 Oct 2009, Stephen Hemminger said:

> On Tue, 20 Oct 2009 19:54:02 +0100
> Nix <nix@esperi.org.uk> wrote:
[...]
>> This makes it much easier to use things like netconsole which bring up a
>> network interface before userspace has started: presently these will cause
>> interface renamings to fail, breaking any userspace that relies on renaming
>> devices to avoid reliance on the potentially-unstable kernel-assigned name.
[...]
> This breaks quagga and other applications that track renames.

So it's only userspace that's the problem? We have a choice of breaking
apps that assume that only downed interfaces can be renamed, and thus
breaking routing while the system is running, or breaking userspaces
that assume that they can rename interfaces, and thus breaking routing
at bootup when netconsole is on? Great :/

(How many systems run things that track renames? Is this, ew, a reason
to make this constraint configurable, maybe even at runtime, so you
could start with interfaces renameable and then lock them down once
static route assignment is up, just before you fire up quagga?)
