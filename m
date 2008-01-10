Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYAJLnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYAJLnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYAJLnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:43:02 -0500
Received: from cantor.suse.de ([195.135.220.2]:33286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYAJLnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:43:00 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 10 Jan 2008 12:42:53 +0100
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist>
In-Reply-To: <20080110112607.GE28740@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101242.53504.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 12:26:07 Adrian Bunk wrote:
> On Thu, Jan 10, 2008 at 12:15:15PM +0100, Andi Kleen wrote:
> > > But your patch does:
> > > 
> > > +config PM_CPUINIT
> > > +       bool
> > > +       depends on PM
> > 
> > That is because arch/x86/power/cpu.c where this happens is currently
> > 
> > obj-$(CONFIG_PM)                += cpu.o
> > 
> > If it was changed to CONFIG_something else then yes that dependency
> > should be changed too.
> 
> 
> Then fix this first.

Rafael indicated he would do that, but it is really outside the scope
of my patch. I was just interested in fixing a linker warning.

> 
> And the following other points you didn't bother to reply to also still 
> stand even after this fix:
> - already __cpuinit code will waste memory with CONFIG_PM_SLEEP=y

Don't know what your point is. Anyways if you think there is a problem
somewhere please feel free to write patches.

> - change shouldn't be x86 specific

CPU initialization is deeply architecture specific. I don't see much use
in generalizing that.

-Andi




