Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbYF3WgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbYF3WgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763191AbYF3WgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:36:10 -0400
Received: from gw.goop.org ([64.81.55.164]:52650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbYF3WgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:36:09 -0400
Message-ID: <48695FD5.7000605@goop.org>
Date: Mon, 30 Jun 2008 15:36:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695ACE.9040806@zytor.com>
In-Reply-To: <48695ACE.9040806@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> H. Peter Anvin wrote:
>>>>
>>>> startup_32:
>>>>         cld
>>>>         /* test KEEP_SEGMENTS flag to see if the bootloader is asking
>>>>          * us to not reload segments */
>>>>         testb $(1<<6), BP_loadflags(%esi)
>>>>         jnz 1f
>>>>
>>>>         cli
>>>>         movl $(__BOOT_DS),%eax
>>>>         movl %eax,%ds
>>>>         movl %eax,%es
>>>>         movl %eax,%fs
>>>>         movl %eax,%gs
>>>>         movl %eax,%ss
>>>> 1:
>
> On this general subject... I keep thinking that it would be better to 
> have this as:
>
>     movl    %cs, %eax
>     addl    $8, %eax
>     movl    %eax, %cs

What's your intent?  You can't directly load %cs; do you mean the other 
segment registers?

>
> ... instead of a hard-coded constant.  That actually removes all 
> hard-coded uses of BOOT_CS/BOOT_DS until we eventually load the 
> kernel's own boot GDT at head_32.S:94.
>
> Does anyone see any problem with that?  As far as I can tell, we're 
> requiring %cs == BOOT_CS for the current code anyway (unless 
> KEEP_SEGMENTS), but %ds == %cs + 8 seems like a more sensible 
> requirement.
>

Oh, you mean

	mov %cs, %eax
	add $8, %eax
	mov %eax, %ds (etc)
?

Seems reasonable.

	J

