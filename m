Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYIFTom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYIFTom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 15:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYIFToV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 15:44:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:36618 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYIFToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 15:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LXZwvg9ghWqId536eTASiVCuDJovaHG5bdwSQZvCHHXGnRiWdupzF91I3JK4V021kj
         UhjJpUBGEE1Z8KDOXF3NGPSiSWx94UnRhMoJTSDrMrkT5qexnviXPYQFYX+/Y6cecJc8
         WhpdRLn+k/DOBrvcALgLq6a/XWXUffdFhns00=
Date: Sat, 6 Sep 2008 23:44:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080906194413.GD23729@lenovo>
References: <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906190446.GA23729@lenovo> <86802c440809061216n5bbad56amabf9934f8bf08d57@mail.gmail.com> <20080906193820.GC23729@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906193820.GC23729@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Sep 06, 2008 at 11:38:20PM +0400]
| [Yinghai Lu - Sat, Sep 06, 2008 at 12:16:28PM -0700]
| | On Sat, Sep 6, 2008 at 12:04 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| | > [Maciej W. Rozycki - Sat, Sep 06, 2008 at 07:45:08PM +0100]
| | > | On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:
| | > |
| | > | > Ingo, how about the following approach? We don't introduce new
| | > | > functions but rather srink the code by new printout form.
| | > |
| | > |  Honestly, this one should probably use sprintf() or suchlike to avoid the
| | > | mess of printk() calls building a line of output from pieces.  It's quite
| | > | easy to calculate here what the maximum size of the buffer required could
| | > | be and automatic arrays can have variable size, so no need for the hassle
| | > | of heap management.  Calls to printk() without a trailing newline should
| | > | be avoided where possible as it messes up logging priority if a message
| | > | pops up from an interrupt inbetween.
| | > |
| | > |   Maciej
| | > |
| | >
| | > The easiest way would be just print this info on separate
| | > lines like
| | >
| | >        IO-APIC (apicid-pin) 1-1 not connected
| | >
| | > and just drop all this troubles :)
| | >
| | > I'm not sure how much memory we need for every io-apic
| | > pins - iirc there only 32 redirection entry so it could
| | > be about 32 bytes from stack would be enough. Will take
| | > a look. Thanks Maciej! Ingo?
| | 
| | no. some system could have 3 or 4 ioapic controller, and every one
| | have 24...(like three mcp55/io55)
| | 4*24
| | 
| | or old system have 1 8111 and 7 8132. will have 32 + 7*2*7
| | 
| | YH
| |
| 
| Didn't really understand all numbers :)
| We have
| 	24	io-apic route entries
| 	128	io-apic maximum in quantity
| 
| so the worst (hardly possible if ever) is when on last io-apic
| all pins are wrong. So for this case we would need
| 
| 	(3 + 1) * ((10 + 1) + (13 + 1)) = 100
| 
| where
| 	3 - strlen("127") - max io-apic number
| 	10 - Sum(strlen(0)+...+strlen(9)) - pin numbers
| 	13 - same sum for two-digit numbers
| 	+1 number - either "-" sign or " "
| 
| 100 bytes to print not connected pins. Ugh :-)
| 
| 		- Cyrill -

But if one day hardware changed - we'll be in troubles :)
So I think better would be just use Ingo's suggestion
about to separate apic/pin iterator and function body.

		- Cyrill -
