Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYEGPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYEGPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762572AbYEGPiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:38:54 -0400
Received: from mail.numalliance.com ([213.41.233.134]:58662 "EHLO
	mail.numalliance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762012AbYEGPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:38:49 -0400
Message-ID: <4821C462.2000108@free.fr>
Date: Wed, 07 May 2008 17:01:54 +0200
From: =?UTF-8?B?U3TDqXBoYW5lIEFOQ0VMT1Q=?= <sancelot@free.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux IDE <linux-ide@vger.kernel.org>
Subject: Re: Compact Flash Question
References: <48215673.3060201@wpkg.org> <e2e108260805070044v42f596bbj39c5b52b6f0a096@mail.gmail.com> <48216039.3070001@wpkg.org> <4821A12F.2020800@aitel.hist.no>
In-Reply-To: <4821A12F.2020800@aitel.hist.no>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

experience report :
In June 2004 we migrated to CF after bad hard disk crashes experience...

Most of the CF do NOT do wear leveling, you have to ask the manufacturer
if it does it or not, generally it is called industrial... and normally,
cost much more .
So, for low cost cf I assume you have to do wear leveling with the
kernel ...otherwise it is already "wear leveling inside"
Since the technology evolves very fast it may be possible today that the
production's cost of wear leveled CF will be the same as standard one
and wear leveling will be a standard ?


I think it should be possible to know if the Cf supports wear leveling
using the the identify device command (0xEC) and look at words 82 to 87 
(cf. CF specifications http://www.compactflash.org/specdl1.htm)
Depending on the application, some system hacks like noatime... need to
be setted up.

we use  silicon systems CF  with wear leveling inside  , we write a few
kb data back each 1/4 h  on it.(log /tmp files  are redirected to ram)

Since June 2004 ALL  hard disk  systems based replaced with CF (env. 100
units)   have not failed.

If somebody could report experience with other brand CF including wear
leveling , it will be fine
some other brand I know only the name :
www.apro-tw.com
http://www.afaya.com.tw/ (spec tells it supports wear leveling)


Best Regards
S.Ancelot

Helge Hafting a écrit :
> Tomasz Chmielewski wrote:
>>
>> How does it work, then?
>> How can it do wear levelling over the whole CF if some (or most) area
>> of CF is already used by our precious data/metadata?
>> It would have to know the areas where no data is stored, but it
>> contradicts the CF <-> filesystem separation.
> It don't necessarily need to know. It can swap two used blocks, one
> often-used and one
> rarely-used.  That way the rarely-used block is rewriten over the
> previously busy
> block, and the busy block is moved to the rarely used area that isn't
> worn.
> This implies an extra write whenever a busy block is moved.  Don't
> know if
> anybody do this, but the technique is simple enough.
>
> CF-filesystem separation is necessary, for they can't know in advance
> what
> filesystem or partitioning scheme will be used.  (I have ext3 on CF,
> for example...)
>
> Helge Hafting
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
