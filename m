Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZC3LWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZC3LWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZC3LWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:22:13 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:35186 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbZC3LWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:22:12 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net A763B2C2F7D
Date: Mon, 30 Mar 2009 13:22:07 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Bodo Eggert <7eggert@gmx.de>, James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: TOMOYO in linux-next
In-Reply-To: <20090329213955.GD31857@elf.ucw.cz>
Message-ID: <alpine.LSU.0.999.0903301202330.4746@be1.lrz>
References: <ck5CF-5mU-11@gated-at.bofh.it> <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org>
 <20090327114224.GF2585@elf.ucw.cz> <alpine.LSU.0.999.0903271354290.5610@be1.lrz>
 <20090329115830.GA15492@elf.ucw.cz> <alpine.LNX.1.10.0903291613360.20606@be10.lrz>
 <20090329213955.GD31857@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, Pavel Machek wrote:

> 
> >>> How would you exclude mozilla from writing to .* then? ".a" is bad,
> >>> ".b" is bad ...? or "A" is OK, "a" is OK, "zzzzzzzzzzzzz" is OK"?
> >>> Either way, you'd need several universes to store the security profile.
> >>
> >> What is magic about .* files? I want mozilla to store the pictures as
> >> .naughty.picture.jpg -- I don't see anything wrong with that.
> >
> > As long as you have a guaranteed-to-be-complete list of config files, you 
> > can get along without wildcards. And still if you do, I'll write a 
> > program to make it incomplete.
> 
> Not all config files match .* pattern. I have at least hugo.ini
> mxmap.ini in my ~.
       ^^^^
I see a pattern there.

IMO there is no use in a security system if it allows you to modify 
something like ~/.bashrc, and a security system not allowing mozilla to 
create ~/.mozilla or ~/pr0n.jpg is not usable at all.

You must handle different files in one directory diffrerently, and since 
they are not there yet, you can't label them. Instead, you'll have to label 
them at runtime, and you have to do it based on the filename. At the same 
time, you have a HUGE number of problematic filenames and a HUGE number of 
safe filenames. Unless you have about 500 universes, you can't implement a 
bitmap of allowed an non-allowed filenames.

What will you do? Give up and let mozilla modify all the config files you 
didn't think of? Or not let mozilla store tux.png in ~?

-- 
Artificial Intelligence usually beats real stupidity.
