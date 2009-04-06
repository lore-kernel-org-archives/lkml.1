Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZDFELY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZDFELY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 00:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZDFELP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 00:11:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:54506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZDFELO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 00:11:14 -0400
Subject: Re: [RFC PATCH] x86, oprofile: fix P4 oprofile CPU setup bug
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Levon <levon@movementarian.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090405213828.GA1059@elte.hu>
References: <1238958725.3522.1.camel@ht.satnam>
	 <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain>
	 <1238962495.3301.0.camel@ht.satnam>  <20090405213828.GA1059@elte.hu>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 09:40:10 +0530
Message-Id: <1238991010.3513.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 23:38 +0200, Ingo Molnar wrote:

> The real fix would be to go to the right abstraction level and 
> realize how these MSRs are set up by the oprofile code, and put all 
> the MSR reads and writes into one non-preempt section.
> 
> Could you please test the patch below? (Totally untested and 
> everything.) Please dont just check whether the warning went away, 
> but also whether Oprofile still works correctly on your P4/HT box.
> 

This fixed the warning, thanks :-)

oprofile is still not working properly may be because of F10 update
issues:
Stopping profiling.
warning: /usr/lib/libpng12.so.0.34.0 could not be found.
warning: /usr/lib/libpurple.so.0.5.4 could not be found.
warning: /vmlinux-unknown could not be found.
warning: [heap] (tgid:3215 range:0x806f000-0x8091000) could not be found.
warning: [heap] (tgid:3243 range:0x806f000-0x8091000) could not be found.
warning: [heap] (tgid:3325 range:0x806f000-0x809b000) could not be found.
warning: [heap] (tgid:3336 range:0x805d000-0x807e000) could not be found.
warning: [heap] (tgid:3510 range:0x806f000-0x8091000) could not be found.
warning: [heap] (tgid:4736 range:0x806f000-0x8091000) could not be found.
warning: [heap] (tgid:5376 range:0x8058000-0x80a8000) could not be found.
bfd_get_section_contents:get_debug:: Bad value

--
JSR

