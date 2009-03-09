Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZCIR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZCIR6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZCIR6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:58:08 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:38475
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751575AbZCIR6H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:58:07 -0400
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KG938D-02-OBO-01
Date: Mon, 9 Mar 2009 18:57:46 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Gene Heskett <gene.heskett@verizon.net>,
       Arjan van de Ven <arjan@infradead.org>,
       Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, tigran@aivazian.fsnet.co.uk
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309175746.GB20716@alberich.amd.com>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com> <20090309081109.376f7a7e@infradead.org> <20090309153449.GB24213@silver.sucs.org> <200903091158.22918.gene.heskett@verizon.net> <20090309162416.GC24213@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090309162416.GC24213@silver.sucs.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Mar 2009 17:57:54.0887 (UTC) FILETIME=[92911570:01C9A0E0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 04:24:16PM +0000, Sitsofe Wheeler wrote:
> On Mon, Mar 09, 2009 at 11:58:22AM -0400, Gene Heskett wrote:
> > Mar  9 07:22:04 coyote kernel: [65725.855365] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin

    ...

> > Mar 9 07:22:04 coyote kernel: [65725.863107] microcode: CPU3 patch
> > does not match (processor_rev_id: 1020, eqiv_cpu_id: 1022) is
> > printed.

This line should better be a debug message. There can be several
ucode-patches in amd-ucode/microcode_amd.bin. The kernel code checks
whether those patches match the CPU revision and if a patch doesn't
match, one such a line shows up. (which is ... obfuscating)

I'll fix this asap in mainline, but IMHO it's not worth to fix this in
.28.

> > Mar 9 07:22:04 coyote kernel: [65725.863120] microcode: CPU3
> > updated from revision 0x1000065 to 0x1000083

Finally CPU microcode was updated as this message is indicating.


Regards,
Andreas


PS: You can check the microcode patch level of your AMD family 10h and
    11h CPU by reading MSR 0x0000008b. E.g. using lsmsr from x86info
    package shows

    # lsmsr -r 0x0000008b -c 0
    PATCH_LEVEL = 0x0000000001000065


-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


