Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZESGje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZESGje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZESGjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:39:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:4651 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZESGjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EbmVjkgpn0klZFRHmCuKXyKnERAHNVp4s8LXmha5/e+zPYzyAoB8nfz3GqxCmqK0zs
         w9sOfWpPvKVeTX4qvnOeG1brouJvTq9XjtNAHKR2DeEENplMsfTU9qFcUft0RPae7zdO
         YQgPoEmVYhnC7bkFcH1EL6E4f2IfoHc0/CJJQ=
MIME-Version: 1.0
In-Reply-To: <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com> 
	<40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com> 
	<alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com> <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 May 2009 23:39:04 -0700
Message-ID: <43e72e890905182339u68c4d4f5v3a2f25e9e3547e60@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: prevent infinite loop
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, jirislaby@gmail.com,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 11:32 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/5/19 Steven Rostedt <rostedt@goodmis.org>:
>>
>> On Tue, 19 May 2009, Nick Kossifidis wrote:
>>>
>>> This is already fixed on wireless-testing ;-)
>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD
>>
>> Thanks, but this does only half. Although I did not hit this in my laptop,
>> it can be an issue. If step[0] == step[1] you have the same problem.
>>
>
> Having the same power value for 2 different steps is something we can
> expect (although docs say that we expect the line to be monotonically
> increasing but anyway), having the same step twice is way out of spec,
> there is no way we can have the same step twice on EEPROM, only if we
> have a corrupted EEPROM (we need to add some sanity checks indeed here
> -> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/eeprom.c;h=c56b494d417acd40d445d922f2861b53cc2315df;hb=HEAD#l910
> to handle such a case but first we need to have a "default" eeprom
> dataset to fallback when we get such errors).

Don't bother with busted EEPROMs, if its busted its busted. Chances
are the complexity we'd need to add to deal with such devices is
simply not worth it.

  Luis
