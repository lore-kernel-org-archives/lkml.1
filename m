Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYDIJ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYDIJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYDIJ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:59:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60923 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYDIJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:59:04 -0400
Date: Wed, 9 Apr 2008 12:03:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
Cc: Andi Kleen <andi@firstfloor.org>, Zhao Forrest <forrest.zhao@gmail.com>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       mingo@elte.hu, ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409100331.GH19010@one.firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 11:50:00AM +0200, Arne Georg Gleditsch wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > "Zhao Forrest" <forrest.zhao@gmail.com> writes:
> >>
> >> As we can see from above information that the physical memory in system
> >> is 32768MB(32GB). However OS is only using about
> >> (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
> >> linux kernel can't use the physical memory remapped
> >> from (4G-512M, 4G) to (32G, 32G+512M)?
> >
> > The linux kernel can only use the memory passed to it by the BIOS.
> > Sometimes they need special BIOS setup options to enable remapping. If
> > there are no such options and you can't upgrade it you're out of luck
> 
> Hm, wouldn't the given e820 map and mtrr listing indicate that 512M were
> actually remapped to 32G+ in this case?

The way it usually works (if it is implemented correctly in the BIOS) 
is that all memory starting at the hole moves up together 
(often subject to DIMM boundaries etc.),
not that the area below the hole is remapped individually.

BTW it is not actually 512MB that is lost. MemTotal does not 
include mem_map and that alone is ~512MB (64 bytes for each 4K page)

So as far as I can see there is no missing memory remapping in Zhao's case, 
he's just confused by the MemTotal semantics.

-Andi
