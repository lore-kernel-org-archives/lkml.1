Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbYKTV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbYKTV2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYKTV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:28:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbYKTV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:28:05 -0500
Message-ID: <4925D596.3010304@zytor.com>
Date: Thu, 20 Nov 2008 13:24:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Luc Verhaegen <lverhaegen@suse.de>, Egbert Eich <eich@suse.de>
Subject: Re: vm86 segfaults with NX bit
References: <s5hmyfu9zl1.wl%tiwai@suse.de>	<20081120085844.6f158e08@infradead.org>	<s5h3ahm9vsb.wl%tiwai@suse.de> <s5hzlju8h00.wl%tiwai@suse.de>
In-Reply-To: <s5hzlju8h00.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
>>>>
>>> did the code that mapped this memory setup use PROT_EXEC ?
>> A good question...
>> Luc, Egbert, how does VESA driver handle it?
> 
> Just looking through the vesa directory of xorg-server code, PROT_EXEC
> is passed for all mappings, at least.
> 
> Please correct me if I'm looking at a wrong place...
> 

Please do an strace of the X server startup up to the point of the crash.

I am betting that PROT_EXEC is missing from an mmap(), or that it needs 
an additional mprotect().

	-hpa

