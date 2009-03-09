Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZCIQYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZCIQYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZCIQYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:24:30 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40044 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZCIQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:24:29 -0400
Date: Mon, 9 Mar 2009 16:24:16 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, tigran@aivazian.fsnet.co.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309162416.GC24213@silver.sucs.org>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com> <20090309081109.376f7a7e@infradead.org> <20090309153449.GB24213@silver.sucs.org> <200903091158.22918.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903091158.22918.gene.heskett@verizon.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the risk of being wrong twice in a row...

On Mon, Mar 09, 2009 at 11:58:22AM -0400, Gene Heskett wrote:
> I'll have to admit it was with some trepidation that I might brick my 
> processor, which is a quad core AMD 9550, stepping 03 running at 2.2 ghz, but 

Microcode patching in this particular fashion (i.e. _not_ updating the
BIOS but "on the fly") is volatile (so it has to be redone at every
boot) which should mean it is very hard to brick a machine this way as
rebooting will undo everything. Of course someone is going to tell me
how they managed to kill a machine stone dead due to some sequence of
events I hadn't thought of and I disclaim any responsiblity if someone
tries to update their microcode and harms their machine in any fashion -
you update at your own risk :).

> the directions didn't note until the end, that it would take a 2.6.29 series 
> kernel to do it and I was running 2.6.28.7.  But when I got to the 
> modprobe -r microcode, modprobe microcode part, there was no feedback from 
> either command.  So did I, or did I not do this as I was and am running 
> 2.6.28.7?  The following was reported in my log:

modprobe generally doesn't return much if the module in question loads
or (as in this case because you were using -r) is removed. That's the
typical Unix command line behviour - no response/output on "OK".

> Mar  9 07:22:04 coyote kernel: [65725.855365] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
> Mar  9 07:22:04 coyote kernel: [65725.863101] microcode: size 1936, total_size 960
> Mar  9 07:22:04 coyote kernel: [65725.863107] microcode: CPU3 patch does not match (processor_rev_id: 1020, eqiv_cpu_id: 1022)
> Mar  9 07:22:04 coyote kernel: [65725.863110] microcode: size 968, total_size 960
> Mar  9 07:22:04 coyote kernel: [65725.863120] microcode: CPU3 updated from revision 0x1000065 to 0x1000083
> Mar  9 07:22:04 coyote kernel: [65725.863122] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> 
> Inquiring minds and all that.  Comments please?

It looks like the firmware file (amd-ucode/microcode_amd.bin) doesn't
match your processor. CC'ing Andreas for comment as you have an AMD
machine...

-- 
Sitsofe | http://sucs.org/~sits/
