Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYCJV1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYCJV1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYCJV1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:27:14 -0400
Received: from gw.goop.org ([64.81.55.164]:59065 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYCJV1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:27:12 -0400
Message-ID: <47D5A778.3020500@goop.org>
Date: Mon, 10 Mar 2008 14:26:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <87myp68r88.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803101707070.3398@blonde.site> <47D57056.3050204@goop.org> <20080310175305.GC7692@one.firstfloor.org> <47D57F86.2020806@goop.org> <47D5A000.6000407@zytor.com>
In-Reply-To: <47D5A000.6000407@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>> Yeah, the most fundamental problem is that the whole page is RO, so 
>> even if Xen trapped and emulated, it still makes a very bad 
>> neighbour.  I was also going to say that there's no reason why you 
>> couldn't pack multiple pgds into one page, but I think we can only 
>> specify the cr3 at page resolution anyway.
>>
>
> Wrong.  With PAE you can specify it at any 32-byte boundary. 

Yes, the x86 lets you, but Xen doesn't - mostly because it reuses the 
lower 12 bits as upper bits of the pfn so that you can specify a 
pagetable base at >4G.

    J
