Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYBBKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYBBKVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYBBKVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:21:04 -0500
Received: from gw.goop.org ([64.81.55.164]:56892 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYBBKVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:21:01 -0500
Message-ID: <47A443E1.1050100@goop.org>
Date: Sat, 02 Feb 2008 02:20:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Subject: Re: [PATCH 3 of 5] x86/pgtable.h: demacro ptep_set_access_flags
References: <patchbomb.1201908323@localhost> <cfac9c32b71b989fe256.1201908326@localhost> <20080202093149.GD12044@elte.hu>
In-Reply-To: <20080202093149.GD12044@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> another thing: these inlines are a bit fat and they are used in more 
> than one place. Please move them into pgtable.c. The rule of thumb is: 
> if an inline is more than 2 lines big, it is a likely candidate for 
> uninlining. (and even many 2-liners, and even some 1-liners are 
> candidates) Especially under paravirt the MMU inlines grow these update 
> notifiers so they become even fatter.
>   

I agree, but I wanted to keep it semantically equivalent to the 
original.  I'll add a move to out of line patch.

> having functions instead of inlines also simplifies the type 
> dependencies by quite a degree.
>   

Indeed, the floating asm/tlbflush.h is a bit of a wart.

    J
