Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYGXTC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYGXTC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYGXTCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:02:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbYGXTCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:02:50 -0400
Date: Thu, 24 Jul 2008 11:59:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
In-Reply-To: <20080724185053.GJ14380@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Suresh Siddha wrote:
> 
> If we don't do init_fpu() + restore from the sane init state, process has
> to be killed, in the paranoid failing scenario of math_state_restore()

Umm. I'm still not seeing why the right answer is not just to do "stts + 
math_used = 0". 

And the specific case of math_state_restore(), that will also fix the 
problem - next time around.

As far as I can tell, your patch causes serious problems in case 
init_fpu() fails. Which it can do, afaik.

			Linus
