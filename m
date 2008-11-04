Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYKDROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYKDROR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYKDROD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:14:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:65229 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYKDROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FFgXZccvSghpgMyzbAjhpAgBUnLbmQFa8WqBQY6unIUq+AkuMpiQUxVyRwF5rrS1wH
         jxdfbL6Ic3uswIKc6uMnnMULIzPJ5RPEuuAghmGDQP+cZMCkJpCp8AK9u7NTj6ggjJEl
         umOKkr1/TRppOSyErN8Bs+7BLlKybw03He0ns=
Date: Tue, 4 Nov 2008 20:13:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104171346.GF21470@localhost>
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com> <20081104140030.GA16178@elte.hu> <1225815789.30706.1282936457@webmail.messagingengine.com> <20081104164717.GD21470@localhost> <20081104165811.GA1664@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104165811.GA1664@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Nov 04, 2008 at 05:58:11PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Alexander van Heukelum - Tue, Nov 04, 2008 at 05:23:09PM +0100]
| > ...
| > | 
| > | I did some timings using the little program below (32-bit only), doing
| > | 1024 times the same sequence. TEST1 is just pushing a constant onto
| > | the stack; TEST2 is pushing the cs register; TEST3 is the sequence
| > | from the patch to extract the vector number from the cs register.
| > | 
| > | Opteron    (cycles): 1024 / 1157 / 3527
| > | Xeon E5345 (cycles): 1092 / 1085 / 6622
| > | Athlon XP  (cycles): 1028 / 1166 / 5192
| > 
| > Xeon is defenitely out of luck :-)
| 
| it's still OK - i.e. no outrageous showstopper overhead anywhere in 
| that instruction sequence. The total round-trip overhead is what will 
| matter most.
| 
| 	Ingo
| 

Don't get me wrong please, I really like what Alexander have done!
But frankly six time slower is a bit scarying me.

		- Cyrill -
