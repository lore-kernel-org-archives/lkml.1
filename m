Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZESGcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZESGcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZESGcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:32:42 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:61193 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZESGcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C02XRzFnNl8XtGWv7PaK2AfOzTZoJSfcnyQixHawHRMGKCOfO4X7jnqBxPrOw9Vudu
         /zpoNxStN1XroQbZQMC2hRAnce/FkDgqQVOA20+IZa+S8WRsKyxiAzDETpJDJ4HhcL6v
         uErIDOjfX0WsNrfdclMPBSch2e5CDmz2RqTXg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com>
	 <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com>
	 <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com>
Date: Tue, 19 May 2009 09:32:42 +0300
Message-ID: <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com>
Subject: Re: [PATCH] ath5k: prevent infinite loop
From: Nick Kossifidis <mickflemm@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com,
       lrodriguez@atheros.com, me@bobcopeland.com,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/19 Steven Rostedt <rostedt@goodmis.org>:
>
> On Tue, 19 May 2009, Nick Kossifidis wrote:
>>
>> This is already fixed on wireless-testing ;-)
>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD
>
> Thanks, but this does only half. Although I did not hit this in my laptop,
> it can be an issue. If step[0] == step[1] you have the same problem.
>

Having the same power value for 2 different steps is something we can
expect (although docs say that we expect the line to be monotonically
increasing but anyway), having the same step twice is way out of spec,
there is no way we can have the same step twice on EEPROM, only if we
have a corrupted EEPROM (we need to add some sanity checks indeed here
-> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/eeprom.c;h=c56b494d417acd40d445d922f2861b53cc2315df;hb=HEAD#l910
to handle such a case but first we need to have a "default" eeprom
dataset to fallback when we get such errors).



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
