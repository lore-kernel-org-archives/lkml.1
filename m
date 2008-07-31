Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYGaL0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYGaL0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYGaL0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:26:45 -0400
Received: from hosted06.westnet.com.au ([203.10.1.221]:38463 "EHLO
	hosted06.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYGaL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:26:44 -0400
Message-ID: <4891A169.30603@snapgear.com>
Date: Thu, 31 Jul 2008 21:26:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
References: <200807300907.25186.arnd@arndb.de> <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com> <3995.1217410495@redhat.com> <Pine.LNX.4.64.0807301422380.3316@anakin> <20080731032338.GA14296@linux-sh.org> <Pine.LNX.4.64.0807310916430.10810@anakin>
In-Reply-To: <Pine.LNX.4.64.0807310916430.10810@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Thu, 31 Jul 2008, Paul Mundt wrote:
>> On Wed, Jul 30, 2008 at 02:26:04PM +0200, Geert Uytterhoeven wrote:
>>> On Wed, 30 Jul 2008, David Howells wrote:
>>>> Arnd Bergmann <arnd@arndb.de> wrote:
>>>>
>>>>> I think the more interesting aspect in m68knommu is what happens
>>>>> when asm-m68k gets moved. Does that work as well?
>>>> Can m68knommu be merged into m68k and be made contingent on CONFIG_MMU?  This
>>>> is what FRV does.
>>> Sure it can ;-)
>>>
>>> Actually I did a bit of work to add nommu support to m68k to make it
>>> boot on old MMU-less Amigas, but it dates back to the 2.6.8.1 era...
>>>
>>> The bigger issue is in those parts that are done differently by m68k and
>>> m68knommu (esp. head.S).
>>>
>>> Who's gonna take the work? :-)
>>>
>> This sort of merging is fairly easy to do incrementally, at least by
>> someone that has both platforms available. An easy first step would be to
> 
> Indeed. I have none of the currently supported m68knommu platforms,
> though.
> Don't know about Greg and m68k platforms (of course he can use ARAnyM
> ;-).

I don't have any real m68k (with MMU) hardware ;-)
I do have a v4e ColdFire with MMU, but that is not supported
by mainline m68k code. Maybe a help...


>> move the m68knommu stuff that are implemented differently over as _nommu
>> files, similar to how the _32/_64 renames happened, and then set about
>> converging the two little by little. This is what I've been doing with
>> sh64->sh integration for example, despite fundamental differences like
>> having a totally different register layout and instruction set.
> 
> IC.

Probably not hugely difficult to merge together. Quite a few of the
m68knommu files came from m68k with only a little change and a lot
of removal. The board/platform stuff is obviously quite different -
very little (if any) commonality.

Just needs someone with time to sit down and do it and clean up
the resulting mess.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
