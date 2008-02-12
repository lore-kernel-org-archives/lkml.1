Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYBLVnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYBLVnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYBLVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:43:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYBLVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:43:42 -0500
Message-ID: <47B212DA.3010503@zytor.com>
Date: Tue, 12 Feb 2008 13:42:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: 464962@bugs.debian.org, Joey Hess <joeyh@debian.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug#464962: immediate crash on boot on TM5800
References: <20080210031849.GA3370@dragon.kitenet.net> <20080210110659.GB8574@stro.at> <20080210192139.GA17647@kodama.kitenet.net> <20080212160522.GB5221@stro.at> <20080212195254.GA6252@kodama.kitenet.net> <20080212201048.GD22054@baikonur.stro.at> <47B2025B.1030103@zytor.com> <20080212210244.GF22054@baikonur.stro.at> <47B20C1C.5020208@zytor.com> <20080212212416.GH22054@baikonur.stro.at>
In-Reply-To: <20080212212416.GH22054@baikonur.stro.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maximilian attems wrote:
> On Tue, Feb 12, 2008 at 01:14:04PM -0800, H. Peter Anvin wrote:
>> Are you sure that build matches the bug report?
> 
> urrgs right sorry, the posted vmlinux is a newer 
> 2.6.24-git22 and not  Version: 2.6.24-3
>  
>> The EIP given falls inside the .data segment of that kernel, 
>> specifically inside the symbol init_task.
>>
>> 	-hpa
> 
> will rebuild aboves.

Okay, the faulting instruction is the following:

c0383360:       0f 1f 40 00             nopl   0x0(%eax)

The Crusoe code morphing software apparently doesn't recognize these 
"long noops", and (presumably) the rest of the hinting NOOP group.  gcc 
didn't use to generate them, and Crusoe/Efficeon generally do not 
benefit from code alignment anyway.  I suspect the best thing to do is 
to use either a 586 kernel or build a dedicated Crusoe kernel without 
code alignment.

	-hpa

