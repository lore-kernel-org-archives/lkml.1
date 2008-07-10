Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYGJRuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYGJRuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYGJRuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:50:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYGJRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:50:32 -0400
Message-ID: <48764BA5.7050104@zytor.com>
Date: Thu, 10 Jul 2008 13:49:25 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Frans Pop <elendil@planet.nl>, Ian Campbell <ijc@hellion.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [regression?] 2.6.26 floppy boot failure with kernel packed using
 'upx'
References: <200807100655.00857.elendil@planet.nl> <alpine.LFD.1.10.0807101015010.11076@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807101015010.11076@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 10 Jul 2008, Frans Pop wrote:
>> Important factor here is that we "pack" the kernel using upx [1] (in order
>> to fit everything on a floppy). The original (unpacked) kernel after this
>> commit boots fine, only a packed version fails.
>> We have tried upx versions 2.01, 3.01 and 3.03, all with same result.
> 
> Ok, I do not consider this to be a regression. 
> 
> Clearly UPX is expecting a very specific kernel format, and clearly UPX 
> just needs to be updated for the changes.
> 
> That said, if some UPX person can explain what it is that UPX needs, maybe 
> we can add some format markers into the kernel (and perhaps some extra 
> header info) so that future format changes are transparent or at least 
> break in obvious ways.
> 

The issue with UPX is that UPX actually wants to replace the kernel 
decompressor, which also does other tasks (relocation and ELF parsing) 
in recent kernels.

	-hpa

