Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYKMIEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYKMIEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYKMIEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:04:23 -0500
Received: from mx1.suse.de ([195.135.220.2]:38244 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYKMIEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:04:23 -0500
Date: Thu, 13 Nov 2008 09:04:21 +0100
From: Bernhard Walle <bwalle@suse.de>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Always use 64 bit addresses for the firmware memory map
Message-ID: <20081113090421.763f7df3@hale.suse.de>
In-Reply-To: <491B6855.1080609@kernel.org>
References: <1226519089-21647-1-git-send-email-bwalle@suse.de>
	<491B358D.2040304@kernel.org>
	<20081112221106.5d9d7801@kopernikus.site>
	<491B6855.1080609@kernel.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin [2008-11-12 15:35]:
>
> Bernhard Walle wrote:
> > * H. Peter Anvin [2008-11-12 11:59]:
> >> I want to make sure, though, that we don't just end up pushing the
> >> truncation further down in the code.
> > 
> > Well, I think that interface should export the BIOS memmap as provided.
> > Since E820 does provide 64 bit addresses, that should get exported.
> > 
> > It should even possible to kexec a PAE kernel from a non PAE kernel ...
> > I didn't test, but it could work. But only if the E820 map is correctly
> > written in the zero page, which is only the case if we get it correctly.
> 
> That's fine, but we do have to check that we don't truncate elsewhere.

What do you mean? That my patch doesn't fix all problems that might
exist but are not yet fixed or that my patch introduces new problems?

Well, for example in the resource reservation code [e820.c,
e820_reserve_resource()] that is handled at line 1285:

		if (end != (resource_size_t)end) {
			res++;
			continue;
		}

My patch only changes the firmware interface, not the architecture
specific code. However, I cannot guarantee that it doesn't break
something, but what action do you expect from me that the patch is
taken?


Regards,
Bernhard

