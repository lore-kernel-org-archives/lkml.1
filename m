Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbXITMF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbXITMF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXITMFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:05:20 -0400
Received: from mailout10.sul.t-online.de ([194.25.134.21]:46159 "EHLO
	mailout10.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbXITMFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:05:18 -0400
Message-ID: <46F261CA.50201@t-online.de>
Date: Thu, 20 Sep 2007 14:04:26 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       David McCullough <David_Mccullough@securecomputing.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com> <20070920031807.GA31263@linux-sh.org>
In-Reply-To: <20070920031807.GA31263@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: VT3E9UZCQhMhVxhDoYmsrdrJytyO2CUfsTvl7xGTNAvLpuom5-dlZ+SZKSjy9+xwAF
X-TOI-MSGID: ba1bca63-0efa-47f9-8bca-c6d4a1d98eee
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> I find it a bit disconcerting that blackfin already depends on this
> in-tree without there being any earlier discussion on making these
> changes.

Parts of the initial submission were picked up (the include/asm 
directory), other's weren't.  Little we can do about that.

>>>>  	 */
>>>>  	if (rev > OLD_FLAT_VERSION) {
>>>> +		unsigned long persistent = 0;
>>>>  		for (i=0; i < relocs; i++) {
>>>>  			unsigned long addr, relval;
>>>>  
>>>> @@ -749,6 +750,8 @@ static int load_flat_file(struct linux_binprm * bprm,
>>>>  			   relocated (of course, the address has to be
>>>>  			   relocated first).  */
>>>>  			relval = ntohl(reloc[i]);
>>>> +			if (flat_set_persistent (relval, &persistent))
>>>> +				continue;
>>>>  			addr = flat_get_relocate_addr(relval);
>>>>  			rp = (unsigned long *) calc_reloc(addr, libinfo, id, 1);
>>>>  			if (rp == (unsigned long *)RELOC_FAILED) {
> 
> I don't much care for this API. It's shuffling around a temporary
> variable for the architecture code that's set for certain relocations
> that are otherwise unhandled.
> 
> Since all the architecture is interested in is the relval that has
> associated "persistent" data encoded in it, why don't we just have a stub
> to give the architecture a chance to validate the relval before the
> flat_get_relocate_addr() and move this stuff there instead? ie, blackfin
> takes this out-of-line and manages its persistent value there.

What is flat_set_persistent other than a stub to validate the relval? 
I'm not at all sure what you're proposing or how it would be different.

> load_flat_file() is ugly enough without dumping more architecture
> callback abuses in it.

The other maintainers who have spoken up didn't seem to think this was 
ugly, or an abuse.  I'm surprised to hear language like that when 
discussing a patch that adds an if statement, a local variable and one 
parameter in a function call.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
