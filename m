Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYKWTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYKWTsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKWTsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:48:31 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:40206 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYKWTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jarSBW8p33av2bsuTfjOJ0/h4Tk4lcG7l8hzSUme3SeyA6Kda9CTqQB1Qww6bawLhz
         ua++4UkhgVrBmLf/gIv+rvW/uqmeAlDoN7Z5ne6qr7QAG4SQpTG89RPe5+3aiWd8+8Rh
         V0sIQYjeq2ertuITEIuiput5OAHfEFVCm8IVY=
Date: Sun, 23 Nov 2008 22:48:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123194828.GQ12710@localhost>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu> <20081123185726.GL12710@localhost> <20081123190025.GD21106@elte.hu> <20081123192243.GP12710@localhost> <20081123193133.GA2794@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123193133.GA2794@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 23, 2008 at 08:31:34PM +0100]
...
| > 
| > Just got an error in implementation -- we have to support nested
| > ENTRY without problem. Will check. What a surprise :-)
| 
| do you mean:
| 
|   ENTRY(system_call)
|   ENTRY(system_call_after_swapgs)
|   ...
|   END(system_call)
| 
| that's more of a bug - system_call_after_swapgs is not a real entry 
| point, we just need the label of it. Perhaps something like __ENTRY() 
| for that case would be enough.
| 
| nor is this one real:
| 
|   ENTRY(interrupt)
|   ENTRY(irq_entries_start)
|   ...
|   END(irq_entries_start)
|   END(interrupt)
| 
| do we really need .irq_entries_start?
| 
| I think in general we should define a flat hierarchy of entries.
| 
| 	Ingo
| 

Yeah, I meant these cases. I don't think we really need irq_entries_start
(didn't find any mention of them in tree). In case of system_call_after_swapgs
I'm not that sure, but since xen use it as a plain jmp (at least now) it
could be converted to a plain label. Ingo, I'll continue tomorrow evening --
have some other things to be done :)

		- Cyrill -
