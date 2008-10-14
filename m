Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYJNJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYJNJDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYJNJDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:03:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:9467 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYJNJDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=mFoPjwr44f+zxCc1qwab7j7uAjbxLdPxaLYtwij4psQNsMJFWsRpGX94mBjGJO/AoE
         g2bHWZlfXCnG28bQiOG9QUPe0BOnk2T9YDhEMV4MBM/Oqce71ujh0/H0RyQ1BBfXyGHr
         kwkq4nj3EQ5EV3CQyaO6GB0LySHM8/RgMqxlE=
Message-ID: <9ea470500810140203l56cbc1d3i9a798580efe91867@mail.gmail.com>
Date: Tue, 14 Oct 2008 11:03:01 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: New CD/DVD reports 'Can Play Audio NO'
Cc: "Nick Warne" <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       "D Bray" <db1986@internetdog.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
In-Reply-To: <48F45D70.7000904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081004103355.407fc303@sauron.linicks.net>
	 <48E82FDB.6020009@kernel.org>
	 <20081005120809.38eb4826@sauron.linicks.net>
	 <48F441F0.90408@kernel.org>
	 <9ea470500810140126v3058d99dn47768834bd087111@mail.gmail.com>
	 <48F45D70.7000904@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[..]

>>> Thanks.  sr.c just doesn't check whether the drive reports audio play
>>> capability or not.  It just sets it while ide-cd actually checks for
>>> the capability.  The drive is not reporting it while it can so ide-cd
>>> needs blacklist entry for it.  Now that idecd has blacklist entry, all
>>> should be fine.  Eh... I'm not sure whether we need to update sr to
>>> follow what ide-cd is doing or not.
>>>
>>> Thanks.
>>
>> Actually, as I already pointed out, I'm not at all happy with blacklisting
>> stuff. What sounds more sane to me (and this is only me) would be what sr.c
>> does: assume that per se the drive can play audio and try to play it. But how
>> many drives are there that cannot play audio, aka, would it be a safe assumption
>> to say that their number is so diminishingly small that it would be better to
>> announce that a drive can play audio by default and fail graciously in the
>> _very_ seldom case it actually cannot ...
>>
>
> Hmm... I don't know.  I think the flag indicates whether the drive has
> DAC and analog audio output, right?

Currently, ide-cd checks the AudioPlay bit advertized in the CD-ROM Capabilities
and Mechanical Status Page.

> I have quite some SATA drives which
> don't have audio output at all.  I haven't check what they report on the
> mode sense page yet.  Eh... well, having the bit set when the drive
> doesn't support it doesn't hurt too much (yet).  Bartlomiej, what do you
> think?

-- 
Regards/Gruss,
Boris
