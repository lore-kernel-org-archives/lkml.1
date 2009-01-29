Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbZA2XRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbZA2XRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZA2XQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:16:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbZA2XQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:16:45 -0500
Date: Fri, 30 Jan 2009 00:16:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: RFC: running out of x86 boot loader IDs
Message-ID: <20090129231641.GC29611@elte.hu>
References: <49823683.6060201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49823683.6060201@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> The 4-bit values used to hold x86 boot loader IDs are near exhaustion.  
> As a result, I'm proposing an extension protocol and will implement it  
> in time for the next merge window unless there are objections.
>
> The proposal will be as follows:
>
> - The boot loader IDs (type_of_loader >> 4) E and F will be reserved:
>
> 	E - extended IDs
> 	F - special uses
>
>   F is consistent with the current use of FF for "unknown".
>
> - If the boot loader ID is E, the current pad1 field at 0x226 is  
> repurposed as an extended loader ID.  The reason to use the pad1 field  
> is that it is present in all headers since version 2.02.  The boot  
> loader ID will simply be: ((extended ID + 0x10) << 4) + (version), where  
> (version) as before is (type_of_loader & 15).  This is the value which  
> will be reported in /proc/sys/kernel/bootloader_type.
>
> The biggest question is probably: is there a need/desire for an extended 
> version field, or is four bits enough for existing bootloader needs?

i think it's prudent to add an extension mechanism, regardless of demand. 
Existing bootloader projects will be content with the IDs they already 
have so they are unlikely to request new ones. Future bootloader projects 
cannot request it because they dont exist yet. So there's no-one to talk 
up.

	Ingo
