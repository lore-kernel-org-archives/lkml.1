Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZLHMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZLHMzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZLHMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:55:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54689 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZLHMzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:55:33 -0500
Date: Tue, 8 Dec 2009 12:55:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
Message-ID: <20091208125530.GA23520@srcf.ucam.org>
References: <4B192D08.9080608@gmail.com> <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 10:05:19AM +0000, Alan Jenkins wrote:

> I think this would benefit from an explanation.
> 
> 
> /* Some models include a placeholder for the TOS6205 device, but don't
> use it */ ?
> 
> /* May be disabled in BIOS */ ?
> 
> /* This device has _STA, not sure why, but let's honour it if disabled */ ?
> 
> 
> That might give us an idea of what to do if we find a model which
> doesn't have _STA :-).

TOS6205 seems to be present even on models which don't have bluetooth, 
and _STA then evaluates appropriately. But having checked, the core 
takes care of this so the driver shouldn't need to.

> I think you _could_ export an rfkill device.  It would at least be
> useful for trouble-shooting, because it lets userspace read the
> current state in a generic way.  So I would recommend doing so in the
> future, even though most current userspaces won't do anything
> interesting with it.  Given that the BIOS sets the state when the
> switch is turned off, I would recommend you expose it as a "hard"
> block - so you don't let userspace change the state.

The problem with that is that there's no event to indicate that the 
switch has been turned back on, so there's no way to update the rfkill 
core appropriately. Giving userspace potentially stale information 
doesn't seem helpful.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
