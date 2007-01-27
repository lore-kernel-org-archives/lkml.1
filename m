Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbXA0JdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbXA0JdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXA0JdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:33:17 -0500
Received: from fw5.argo.co.il ([194.90.79.130]:1824 "EHLO argo2k.argo.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751087AbXA0JdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:33:16 -0500
Message-ID: <45BB1C53.8010708@argo.co.il>
Date: Sat, 27 Jan 2007 11:33:07 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Support for i386 PATs
References: <45BB1952.8000903@tungstengraphics.com>
In-Reply-To: <45BB1952.8000903@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jan 2007 09:33:10.0045 (UTC) FILETIME=[287DECD0:01C741F6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:
> Hi!
>
> Does anybody have a strong opinion against adding support for
> i386 Page Attribute Tables?
>
> The main benefit would be that one can have write-combining memory
> regions without setting up MTRRs. This will come in handy for a
> device we're working with where the device driver needs to allocate the
> display memory directly from system memory, and it may be difficult to 
> fit
> the mtrr alignment constraints.

An additional benefit if that you can easily run out of mtrrs.  My home 
machine boots with all 8 mtrrs used, leaving none for the G965 
graphics.  I have to compress two mtrrs into one in order to get decent 
performance.

>
> Outline:
> The PAT may be set up at boot time with fixed backwards-compatible
> memory types for the different PAT entries + defines like the following:
>
> #define _PAGE_PAT_WB   xxx
> #define _PAGE_PAT_WT   xxx
> #define _PAGE_PAT_UC0 xxx
> #define _PAGE_PAT_UC1 xxx
> #define _PAGE_PAT_WC   xxx
>
> which can be used in parallel with the old _PAGE_PWT and _PAGE_PCD bits.
>
> The idea is that new memory types, WC for example, will use the pat 
> entries
> 7 downto 4, whereas 0-3 are left to boot setting to maintain backwards 
> compatibility.
>
> Issues:
> 1) The _PAGE_BIT_PAT will be the same as _PAGE_PSE, and _PAGE_PROTNONE.
> As I understand it, _PAGE_PROTNONE is not used when the page is 
> present, so this might not be an issue.
> What about _PAGE_PSE?

pse pages place the pat bit in bit 12, you will need to account for that.



-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

