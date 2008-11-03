Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYKCSAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYKCSAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKCSAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:00:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10579 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYKCSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=L6akbEN8utX0si2TDwkrvWlonys/+JPFIt8BCPtA4jl+ZqMgMVBHNfrdMT1GvkRaYV
         tDCH5vdIpvmBJKnt+W1z8fPLTUfDVa1Ei0cyDtO+jAsAaEtDnja9UeXuoTtkHB3DsQOP
         zrfhBR5umCmRYYaLgX1dO63ZarJy9HPxeomlI=
Message-ID: <490F3C44.7080504@tuffmail.co.uk>
Date: Mon, 03 Nov 2008 18:00:36 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: rfkill, stupid question #6
References: <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net> <20081103141836.GA31894@srcf.ucam.org> <490F0ACC.4000808@tuffmail.co.uk> <20081103145145.GD31078@khazad-dum.debian.net> <20081103145543.GA496@srcf.ucam.org> <20081103150229.GF31078@khazad-dum.debian.net> <20081103150843.GA1107@srcf.ucam.org> <20081103163311.GA2417@khazad-dum.debian.net>
In-Reply-To: <20081103163311.GA2417@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 03 Nov 2008, Matthew Garrett wrote:
>   
>> On Mon, Nov 03, 2008 at 01:02:29PM -0200, Henrique de Moraes Holschuh wrote:
>>     
>>> Right now, you should still rfkill_force_state().  Please wait for an hour
>>> or two while I clean up that broken resume handling, and I will tell you for
>>> sure.
>>>       
>> Cool. I'll hold off posting my cleanups until then in that case.
>>     
>
> Ok, two bugs reproduced, the fixes are ready and tested, and I will be
> sending it now to linux-wireless.  You're in the CC, so you will get them.
>
> I will also need to send patches for -stable, as the ones for mainline won't
> apply to -stable.
>
> Now, for what you asked: you DO NOT HAVE to use rfkill_force_state() in your
> driver's resume method, as long as you NEVER make use of
> RFKILL_STATE_HARD_BLOCKED.   I have fixed the bug that was messing this up.
>   

Thanks for fixing this, even though it doesn't affect my
non-STATE_HARD_BLOCKED-using hardware.

I have one more question.  I read that if a STATE_SOFT_BLOCKED request
is made when the hardware is in STATE_HARD_BLOCKED, the rfkill driver is
expected to "double block".

If the hard block is later cleared, the driver is expected to call
rfkill_force_state(SOFT_BLOCKED).  The SOFT_BLOCKED state can then be
cleared as normal.

But if there is an UNBLOCK request in the double-blocked state, the
rfkill core will reject it and preserve the  double-blocked state.  Is
this intended, or a known issue?

Wouldn't it be simpler to use a bitmask so that the rfkill core can at
least represent this double-blocked state?  I guess the problem would be
how to shoehorn it into the sysfs interface.

Thanks
Alan
