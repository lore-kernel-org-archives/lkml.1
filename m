Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZGUKpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZGUKpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZGUKpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:45:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:51540 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbZGUKpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:45:08 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dN1402I1442Jzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN4OIM-03-H6Q-01
Date: Tue, 21 Jul 2009 12:44:43 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com,
       aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090721104443.GC32338@aftab>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
 <1248106385-27514-8-git-send-email-borislav.petkov@amd.com>
 <20090720180446.GB16072@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090720180446.GB16072@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 10:44:43.0344 (UTC) FILETIME=[41C0DD00:01CA09F0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:04:46PM +0200, Andi Kleen wrote:
> On Mon, Jul 20, 2009 at 06:12:58PM +0200, Borislav Petkov wrote:
> > Use a weakly defined symbol instead of ugly ifdefs.
> 
> I'm not sure what you're trying to archive, but if you're
> trying to catch corrected MCs you're hooking into the 
> wrong function. print_mce is only called for PCC=1.

Well, I was able to mce-inject a PCC=0 MCE with UC set:

HARDWARE ERROR
CPU 0: Machine Check Exception:                0 Bank 5: b400200000000f0f
TSC a84597c1a0 ADDR 1234 
PROCESSOR 2:100f22 TIME 1248092118 SOCKET 0 APIC 0
MC5_STATUS: Uncorrected error, report: yes, MiscV: invalid, CPU context corrupt: no
 FR Error: CPU Watchdog timer expire.
 Transaction type: Generic(Generic), Timed out, Cache Level: L3/Generic, generic
This is not a software problem!

Irrespective, I'm more focused on decoding all MCEs that are graded to
be output, no matter the severity and obviate the staring and meditating
on MC5_STATUS (0xb400200000000f0f) for example while trying to decipher
what kind of error it was. Long term, we'd like to do more decoding
depending on the error type and use EDAC for that.

> Also if you're checking for specific banks you
> need to check for vendor/cpu model first of course.
> In your current implementation e.g. a Intel CPU
> would pass some random event into your AMD specific code,
> which is probably not intended and might even crash.

Actually I wanted to worry about that only after we have more than one
vendor-specific MCE decoders :).
 
> It would be probably cleaner if you defined a standard
> notifier chain interface.

Sounds like a cleaner solution, at a first glance. Will look into it.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

