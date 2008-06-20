Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYFTOBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYFTOBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYFTOBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:01:47 -0400
Received: from ns.suse.de ([195.135.220.2]:58867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbYFTOBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:01:46 -0400
Date: Fri, 20 Jun 2008 16:02:23 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [PATCH] Unify crashkernel reservation for 32 and 64 bit
Message-ID: <20080620160223.4a0f1dd8@halley.suse.de>
In-Reply-To: <20080620135645.GD8135@elte.hu>
References: <1213969102-17400-1-git-send-email-bwalle@suse.de>
	<20080620135645.GD8135@elte.hu>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
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

* Ingo Molnar [2008-06-20 15:56]:
> * Bernhard Walle <bwalle@suse.de> wrote:
> 
> > This patch moves the reserve_crashkernel() to setup.c and removes the 
> > architecture-specific version. Both versions were more or less the 
> > same.
> 
> famous last words :)
> 
> can you see any functionality difference between them? If yes, that 
> should be declared.

The only difference was the calculation of memory -- it's more
complicated on i386 because of high memory support, so that was
outsourced to an inline function. However, because the highmem is in

  #ifdef CONFIG_HIGHMEM
  #endif

and CONFIG_HIGHMEM is off on x86-64, that doesn't matter. Do you see
another issue?

I tested it on both x86-64 and i386, with CONFIG_KEXEC on and off (so
that it compiles).



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
