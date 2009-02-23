Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZBWQ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZBWQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZBWQ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:27:45 -0500
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:44470
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZBWQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:27:44 -0500
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 11:27:44 EST
MIME-Version: 1.0
Date: Mon, 23 Feb 2009 11:16:51 -0500
From: <pat-lkml@erley.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Jiri Slaby <jirislaby@gmail.com>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
       <ath5k-devel@venema.h4ckr.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten =?UTF-8?Q?=28ath=35k=5Frx?=
 =?UTF-8?Q?=5Fskb=5Falloc=29?=
In-Reply-To: <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com>
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com>
Message-ID: <ee884e22dfd15885de1299d4396dbb2a@127.0.0.1>
User-Agent: RoundCube Webmail/0.2-beta
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 18:03:16 +0200, Nick Kossifidis <mickflemm@gmail.com>
wrote:
> 2009/2/23 Bob Copeland <me@bobcopeland.com>:
>> On Mon, 23 Feb 2009 00:20:50 +0100, Jiri Slaby wrote
>>> On 22.2.2009 22:56, Jiri Slaby wrote:
>>> > Well, maybe we should try to reproduce with jumbo packets sent to the
>>> > ath5k receiver, since I think it (1) is not very much test-covered
>>> > code
>>> > (2) appears to be related.
>>>
>>> According to the spec I have for older chip, there is not `done' flag
>>> set for descriptors which have `more' flag set. We handle this wrongly.
>>> Am I looking correctly, Nick, Luis, Bob?
>>>
>>> I still don't see what could have caused this though.
>>
>> As I understand it, yes, we don't do the right thing when the more flag
>> is set.  We're supposed to keep processing packets until we get one with
>> the done flag, and then all of that is supposed to be merged into a
>> single
>> packet.  Other flags such as the rx rate are only valid on the final
>> packet.
>>
>> However, I did some debugging of this a while ago and concluded that the
>> 'jumbo' frames were largely garbage data.  The dma buffer size is
>> certainly
>> large enough for a standard 802.11 frame and the 'more' flag is only
>> supposed to be set if the dma buffer size is too small for a packet.  In
>> all cases the dma buffer size was 2500+ bytes and the actual contents of
>> the packets looked like random values (I did have encryption turned on,
>> but there were no 802.11 headers I could see.)
>>
>> So I am not sure if the jumbo packets are causing bad things to happen,
>> or if they are an indication that something bad has already happened.
>>
> 
> Hmm can someone test ath5k against an Atheros AP using fast frames ?
> Maybe they are jumbo frames but they don't have any header etc so that
> they look like one frame after un-fragmentation, documentation says
> that the current frame is continued in the next descriptor if more is
> set to 1 so i guess next buffer might not have the header. If more = 0
> then it's our last descriptor and only then other fields such as done,
> frame receive ok, rssi etc are valid.

If an ath9k device in AP mode using hostapd counts as an Atheros AP, then I

can test tonight.  If you can send me the steps to test this, I'll do it in

about 8 hours.

Pat Erley
