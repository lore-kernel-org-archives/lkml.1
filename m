Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220Ab0ASWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0ASWa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420Ab0ASWa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:30:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60115 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0ASWa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:30:56 -0500
Message-ID: <4B56328E.9080108@zytor.com>
Date: Tue, 19 Jan 2010 14:30:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
References: <alpine.DEB.2.00.1001191616280.28622@router.home>
In-Reply-To: <alpine.DEB.2.00.1001191616280.28622@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 02:21 PM, Christoph Lameter wrote:
> 
> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: [x86] Unify semaphore_32.S and rwlock_64.S
> 
> Both implement semaphore handling and the code for __read_lock_failed()
> and __write_lock_failed() look eearily similar aside from the use of
> different registers.
> 
> Create a new arch/x86/lib/semaphore.S out of the two files.
> 

Hi Christoph,

Could you do this in the standard sequencing for unification patches:
first patch the two pieces of code so they are identical, and then
mechanically unifying them?  Otherwise it's almost impossible to see
what has changed.

> This is also a good preparatory patch for getting the rwsem XADD stuff
> to work on x86_64.

Have you tried the tip:x86/rwsem branch (Linus' work with a few
additions of mine) and had it not work for you?

> x86_64 gains the FRAME/ENDFRAME handling that i386 has (not sure what the
> point is of having that there).

Presumably it's so you can have frame pointers everywhere.

	-hpa
