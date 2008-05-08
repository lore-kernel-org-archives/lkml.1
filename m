Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbYEHUVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbYEHUVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYEHUVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:21:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60279 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYEHUVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:21:24 -0400
Date: Thu, 8 May 2008 22:22:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Subject: Re: How to link a .o with all modules
Message-ID: <20080508202200.GA12578@uranus.ravnborg.org>
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org> <20080504192434.GA23752@uranus.ravnborg.org> <D346E2E4-26C3-482E-ABBF-AF1EE97E91CD@kernel.crashing.org> <20080505204449.GA9446@uranus.ravnborg.org> <5DD68A6B-45FD-4163-BDF5-356C70A00676@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5DD68A6B-45FD-4163-BDF5-356C70A00676@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:16:10AM -0500, Kumar Gala wrote:
> 
> On May 5, 2008, at 3:44 PM, Sam Ravnborg wrote:
> 
> >>>
> >>>
> >>>Let me know if this does address your question.
> >>
> >>The problem is MODPOST complains about undefined symbols:
> >>
> >> MODPOST 24 modules
> >>ERROR: "_restgpr_20_x" [net/key/af_key.ko] undefined!
> >>ERROR: "_restgpr_25_x" [net/key/af_key.ko] undefined!
> >>ERROR: "_restgpr_30_x" [net/key/af_key.ko] undefined!
> >
> >I need a bit more context to try to analyse this.
> >Where did you expect _restgpr_20_x to be defined.
> >If in vmlinux then were they present in the
> >Module.symvers file?
> 
> No they aren't there since we I'm not EXPORT_SYMBOL() them.  Should I  
> also be doing EXPORT_SYMBOL?

So modpost claim it cannot find the symbols.

> 
> >If in the linked in .o file - could you
> >see the symbols using objdump.
> 
> Yes.
> 
> readelf -a:
> 
> ...
> Symbol table '.symtab' contains 113 entries:
>    Num:    Value  Size Type    Bind   Vis      Ndx Name
> ...
>      5: 00000000     0 FUNC    GLOBAL DEFAULT    1 _savegpr_14
>      6: 00000000     0 FUNC    GLOBAL DEFAULT    1 _save32gpr_14
> ...

Strange.

I did not look closer.
But it looks like the linker failed to resolve these symbols
in the final link somehow - despite the symbols are present in
the linked in .o file.

Can you try to drop me the output of the relocation records for the
finally linked .o file (the one with your .o file linked in).

objdump -r IIRC

	Sam
