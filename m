Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbYKWLfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbYKWLfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYKWLfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:35:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:36198 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbYKWLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gGDs+VwtpFyC6V+B7IjSrQB5rGEyltepVRgxKeKSLr5nZgAAUeN3rZM8E/NPbFc11u
         PtA5fNLvW9gD9nTgcRHBAK01UUMzCG9G70L2oC0vCWJjzygBlJJOWQ6imLRIeCEuRePA
         ekMZO9Ugi6VlDYcl0fgNu8j1bVsj6rpFUupZA=
Date: Sun, 23 Nov 2008 14:35:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
Message-ID: <20081123113540.GE24818@localhost>
References: <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123092136.GC24818@localhost> <20081123112354.GA31667@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123112354.GA31667@mailshack.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Sun, Nov 23, 2008 at 12:23:54PM +0100]
| On Sun, Nov 23, 2008 at 12:21:36PM +0300, Cyrill Gorcunov wrote:
| > [Alexander van Heukelum - Sun, Nov 23, 2008 at 10:08:28AM +0100]
| > | Impact: cleanup of entry_64.S
| > | 
| > | Except for the order and the place of the functions, this
| > | patch should not change the generated code.
| > | 
| > | Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| > | 
| > | ---
| > |  arch/x86/kernel/entry_64.S |  259 +++++++++++++++++++-------------------------
| > |  1 files changed, 109 insertions(+), 150 deletions(-)
| > |
| > 
| > Hi Alexander,
| > 
| > great! One moment is not obvious for me -- why we
| > stopped to align interrupt section to 32 bytes?
| > Did I miss anyhing?
| 
| I put a ".p2align 5" in earlier in the series which caused the
| apicinterrupts to be 32-byte aligned. But it is a hack, really,
| relying on the generated code per stub to be between 17 and 32
| bytes, on the default alignment to be 16 bytes and all stubs
| to be in the .text section.
| 
| I'm in favour of aligning all of the interrupt/exception stubs
| to 32 bytes, but it should be implemented the right way ;),
| which means that we need KPROBE_ENTRY_P5ALIGNED and so on :-/.
| 
| Greetings,
|         Alexander
|  
| > 		- Cyrill -
| 

ah. thanks for info.

		- Cyrill -
