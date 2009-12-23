Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZLWSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZLWSLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZLWSLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:11:24 -0500
Received: from mx2.compro.net ([12.186.155.4]:14623 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605AbZLWSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:11:23 -0500
X-IronPort-AV: E=Sophos;i="4.47,443,1257138000"; 
   d="scan'208";a="4812078"
Message-ID: <4B325D4A.5090304@compro.net>
Date: Wed, 23 Dec 2009 13:11:22 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net> <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain> <4B2BE05B.9050006@compro.net> <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain> <4B30E1B4.7000702@compro.net> <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain> <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <alpine.LFD.2.00.0912230955590.6879@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912230955590.6879@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 01:01 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 23 Dec 2009, Mark Hounschell wrote:
>>
>> I'll try the patch Linus provided now.
> 
> I doubt it matters - because if it did, it would matter for everybody, and 
> the HPET thing shouldn't make any difference at all.
> 
> [ Or rather, it should matter for everybody trying to format a specific 
>   format (without interleave it won't matter, and not all formats have any 
>   interleave - I think it was mainly used on 5.25" floppies and special 
>   formats). ]
> 
> Besides, maybe I was just mis-reading the code.
> 
> But getting some testing for the patch certainly won't hurt, so I'm not 
> going to argue against it any more ;)

Yea, that hosed it up pretty good. The very first track label sent out
caused some sort of timeout.

Dec 23 13:10:02 harley kernel:
Dec 23 13:10:02 harley kernel: floppy driver state
Dec 23 13:10:02 harley kernel: -------------------
Dec 23 13:10:02 harley kernel: now=9017 last interrupt=8117 diff=900 last
called handler=f73ce27d
Dec 23 13:10:02 harley kernel: timeout_message=lock fdc
Dec 23 13:10:02 harley kernel: last output bytes:
Dec 23 13:10:02 harley kernel:  0 90 4294899106
Dec 23 13:10:02 harley kernel: 1a 90 4294899106
Dec 23 13:10:02 harley kernel:  0 90 4294899106
Dec 23 13:10:02 harley kernel:  3 90 4294899106
Dec 23 13:10:02 harley kernel: c1 90 4294899106
Dec 23 13:10:02 harley kernel: 10 90 4294899106
Dec 23 13:10:02 harley kernel:  7 80 4294899106
Dec 23 13:10:02 harley kernel:  0 90 4294899106
Dec 23 13:10:02 harley kernel:  8 81 4294899106
Dec 23 13:10:02 harley kernel:  4 80 4294899106
Dec 23 13:10:02 harley kernel:  0 90 4294899106
Dec 23 13:10:02 harley kernel: e6 80 8007
Dec 23 13:10:02 harley kernel:  0 90 8007
Dec 23 13:10:02 harley syslog-ng[2651]: last message repeated 2 times
Dec 23 13:10:02 harley kernel:  1 90 8007
Dec 23 13:10:02 harley kernel:  2 90 8007
Dec 23 13:10:02 harley kernel: 12 90 8007
Dec 23 13:10:02 harley kernel: 1b 90 8007
Dec 23 13:10:02 harley kernel: ff 90 8007
Dec 23 13:10:02 harley kernel: last result at 8117
Dec 23 13:10:02 harley kernel: last redo_fd_request at 8117
Dec 23 13:10:02 harley kernel:
Dec 23 13:10:02 harley kernel: status=80
Dec 23 13:10:02 harley kernel: fdc_busy=1
Dec 23 13:10:02 harley kernel: cont=f73d58e4
Dec 23 13:10:02 harley kernel: current_req=(null)
Dec 23 13:10:02 harley kernel: command_status=-1
Dec 23 13:10:02 harley kernel:
Dec 23 13:10:02 harley kernel: floppy0: floppy timeout called
Dec 23 13:10:22 harley kernel:
Dec 23 13:10:22 harley kernel: floppy driver state
Dec 23 13:10:22 harley kernel: -------------------
Dec 23 13:10:22 harley kernel: now=15017 last interrupt=8117 diff=6900 last
called handler=f73ce27d
Dec 23 13:10:22 harley kernel: timeout_message=do wakeup
Dec 23 13:10:22 harley kernel: last output bytes:
Dec 23 13:10:22 harley kernel:  0 90 4294899106
Dec 23 13:10:22 harley kernel: 1a 90 4294899106
Dec 23 13:10:22 harley kernel:  0 90 4294899106
Dec 23 13:10:22 harley kernel:  3 90 4294899106
Dec 23 13:10:22 harley kernel: c1 90 4294899106
Dec 23 13:10:22 harley kernel: 10 90 4294899106
Dec 23 13:10:22 harley kernel:  7 80 4294899106
Dec 23 13:10:22 harley kernel:  0 90 4294899106
Dec 23 13:10:22 harley kernel:  8 81 4294899106
Dec 23 13:10:22 harley kernel:  4 80 4294899106
Dec 23 13:10:22 harley kernel:  0 90 4294899106
Dec 23 13:10:22 harley kernel: e6 80 8007
Dec 23 13:10:22 harley kernel:  0 90 8007
Dec 23 13:10:22 harley syslog-ng[2651]: last message repeated 2 times
Dec 23 13:10:22 harley kernel:  1 90 8007
Dec 23 13:10:22 harley kernel:  2 90 8007
Dec 23 13:10:22 harley kernel: 12 90 8007
Dec 23 13:10:22 harley kernel: 1b 90 8007
Dec 23 13:10:22 harley kernel: ff 90 8007
Dec 23 13:10:22 harley kernel: last result at 8117
Dec 23 13:10:22 harley kernel: last redo_fd_request at 8117
Dec 23 13:10:22 harley kernel:
Dec 23 13:10:22 harley kernel: status=80
Dec 23 13:10:22 harley kernel: fdc_busy=1
Dec 23 13:10:22 harley kernel: floppy_work.func=f73d03da
Dec 23 13:10:22 harley kernel: cont=f73d5274
Dec 23 13:10:22 harley kernel: current_req=(null)
Dec 23 13:10:22 harley kernel: command_status=-1
Dec 23 13:10:22 harley kernel:
Dec 23 13:10:22 harley kernel: floppy0: floppy timeout called
Dec 23 13:10:22 harley kernel: floppy.c: no request in request_don

Have to reboot now...

Mark
