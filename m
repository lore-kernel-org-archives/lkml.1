Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbZJMFpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbZJMFpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbZJMFpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:45:13 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:45639
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755594AbZJMFpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:45:12 -0400
X-IronPort-AV: E=Sophos;i="4.44,550,1249250400"; 
   d="scan'208";a="48484298"
Message-ID: <4AD41373.8010108@inria.fr>
Date: Tue, 13 Oct 2009 07:43:15 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu>
In-Reply-To: <20091012202046.GA7648@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>
>   
>> On Mon, Oct 12, 2009 at 08:19:44PM +0200, Ingo Molnar wrote:
>>
>>     
>>>> After that point the scheme is perfectly lossless.
>>>>         
>>> Well if it can OOM it's not lossless, obviously. You just define 
>>> "event loss" to be equivalent to "Destruction of the universe." ;-)
>>>       
>> It can't OOM once the ummunotify registration is done - when an event 
>> occurs it doesn't allocate any memory and it doesn't loose events.
>>     
>
> Well, it has built-in event loss via the UMMUNOTIFY_FLAG_HINT mechanism: 
> any double events on the same range will cause an imprecise event to be 
> recorded and cause the loss of information.
>   

The target (MPI) application doesn't care about how many events are
coming here. It just needs to know whether something has been
invalidated in the range. If so, it destroy the whole RDMA window
anyway. So it's actually _good_ that multiple events are merged into a
single one: the application only has to process a single event per
partially-invalidated range.

Brice

