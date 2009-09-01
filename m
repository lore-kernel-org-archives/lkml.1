Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZIANG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZIANG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZIANGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:06:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:36381 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZIANGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:06:24 -0400
X-SpamScore: -15
X-BigFish: VPS-15(z34a4jz1432R98dN1b0bMa594izz1202hzzz32i247h203h6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KPAN2F-02-1F4-02
X-M-MSG: 
Date: Tue, 1 Sep 2009 15:06:28 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, msr: Add rd/wrmsr interfaces with preset
 registers
Message-ID: <20090901130628.GC27876@aftab>
References: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
 <tip-132ec92f3f70fe365c1f4b8d46e66cf8a2a16880@git.kernel.org>
 <20090901110513.GA24120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090901110513.GA24120@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Sep 2009 13:06:14.0993 (UTC) FILETIME=[FC852C10:01CA2B04]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 01:05:13PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > Commit-ID:  132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
> > Gitweb:     http://git.kernel.org/tip/132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
> > Author:     Borislav Petkov <petkovbb@googlemail.com>
> > AuthorDate: Mon, 31 Aug 2009 09:50:09 +0200
> > Committer:  H. Peter Anvin <hpa@zytor.com>
> > CommitDate: Mon, 31 Aug 2009 15:14:26 -0700
> > 
> > x86, msr: Add rd/wrmsr interfaces with preset registers
> 
> FYI, -tip testing found a build failure on x86 with these patches:
> 
> arch/x86/lib/msr-reg.S:14: Error: Bad macro parameter list
> arch/x86/lib/msr-reg.S:100: Error: invalid character '_' in mnemonic
> arch/x86/lib/msr-reg.S:101: Error: invalid character '_' in mnemonic
> 
> config attached. I've excluded this topic branch from tip:master for 
> now.

I can't trigger it here.

Stab in the dark: It could be an old binutils issue since gas can't
swallow the macro definition. If you're building on a RHEL system,
it could be that the ":req" macro argument specification is not
supported by that particular version of the gnu assembler as
http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/gnu-assembler/macro.html
doesn't state anything on required macro arguments.

Try removing the ":req" part if the op macro argument to see whether it
builds. If so, ":req" is not absolutely necessary and we can do away
without it.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

