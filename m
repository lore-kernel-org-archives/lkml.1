Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbZIPElX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbZIPElX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZIPElW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:41:22 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:59209 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZIPElV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:41:21 -0400
X-SpamScore: 2
X-BigFish: VPS2(zz1432R98dNzz1202hzz3198u327alz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ1ROR-02-7HJ-02
X-M-MSG: 
Date: Wed, 16 Sep 2009 06:40:29 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] compile error with edac_mce_amd.c as module
Message-ID: <20090916044029.GA5767@aftab>
References: <1253044479.20020.125.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253044479.20020.125.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Sep 2009 04:40:32.0588 (UTC) FILETIME=[D33BD8C0:01CA3687]
X-Reverse-DNS: ausb3extmailp02.amd.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 03:54:39PM -0400, Steven Rostedt wrote:
> The file drivers/edac/edac_mce_amd.c references a kernel variable that
> is not exported for modules.
> 
>  ERROR: "per_cpu__cpu_llc_id" [drivers/edac/edac_core.ko] undefined!
> 
> 
> The variable in question is located in arch/x86/kernel/smpboot.c
> 
> /* Last level cache ID of each logical CPU */
> DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
> 
> and is not exported to modules.
> 
> This is from the latest Linus repo. I can supply a config if requested.

Sorry for that, proper fix is already there:
http://marc.info/?l=linux-kernel&m=125302459621925

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

