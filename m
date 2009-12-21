Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZLUTx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZLUTx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZLUTx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:53:59 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:50083 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLUTx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:53:58 -0500
Message-ID: <4B2FD252.4060700@msgid.tls.msk.ru>
Date: Mon, 21 Dec 2009 22:53:54 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Michael Guntsche <mike@it-loops.com>
CC: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org> <4B2E084D.6080105@msgid.tls.msk.ru> <20091220141156.GA3744@merkur.ravnborg.org> <4B2F8369.2060708@suse.cz> <20091221162846.GA3529@gibson.comsick.at>
In-Reply-To: <20091221162846.GA3529@gibson.comsick.at>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Guntsche wrote:
> On 21 Dec 09 15:17, Michal Marek wrote:
>>> How about moving this functionality to mkpiggy where we are
>>> less shell script dependent.
>>>
>>> Something like the following.
>>> I have only tested it lightly (vmlinux.bin did not differ
>>> before/after the patch.
>>
>> I think that it's a good idea to move this out of the makefiles. But for
>> 2.6.33, I think I prefer the patch from Andreas, provided he signs it
>> off and Michael G confirms that it fixes his issue.
> 
> Just a quick update from my side. I tried the patch from Andreas and build a kernel
> with dash as defaulti shell. I was able to boot the resulting kernel image
> without any problems.

That's not a good test case.  Because even with bogus data the kernel might
boot: for example, allocating alot more memory for the unpacking than necessary -
it does not crash but the data is still bogus.

The better (and much faster) check is to verify that the z_output_len value
in arch/x86/boot/compressed/piggy.S matches the size of
arch/x86/boot/compressed/vmlinuz.bin.

/mjt
