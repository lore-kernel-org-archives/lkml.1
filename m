Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZKQPEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZKQPEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZKQPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:04:34 -0500
Received: from web53409.mail.re2.yahoo.com ([206.190.37.56]:46466 "HELO
	web53409.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751986AbZKQPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:04:34 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 10:04:34 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=IRzH4+bun1T6bEAhL4gaR1Bn/0OF+1pt2tyTEQYFgi5+am6b0AnXo7nuM/1OOd1Pjqdp1ICxVJrOD+9A5jSip2mXmTJx27BVcqh7OK/6KoSKFv0O33PxiS916zxkAIepnCf6aIvUJuclKOzBPGM1R9x6YcBbJ4cn4fRUKAeIZPo=;
Message-ID: <892565.78973.qm@web53409.mail.re2.yahoo.com>
X-YMail-OSG: XYN5xwoVM1mZEikpHUtaGnzASo.20hgiQLRVoTy4zWPpb3Bi.ZPJIykj8vorVPbfZ5QBcc9joc9IDXfvfUw97fHg22H1V0RVR72IuYN8YzDI7bLB9rNbpBMl5nzgbpSe4fGkFCIcmcFTpQRNsFIE1AqNbIH4qzz3w5rAj4GPQrj_tuOtIS40dHJGZ3COa5DW2nLUFJZzVQyjY7iq9CrQRqGPLjerPAtdRH6CdmYL39.9ij0yPzOP7IPQ391eLCcf6KP1PMWkhCa9Im2D4tXHD0OAWFeSYXp7w6WGSr1omcvhZR03ULuGnepuKtUuaHndvm0n845AOLVPc8xKOkPSkpz0b_ExQEXosKRJN3lh8ZioaIB2SfiAvq0hnLLL
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
References: <768725.48321.qm@web53403.mail.re2.yahoo.com> <4B02AD9B.5040105@msgid.tls.msk.ru>
Date: Tue, 17 Nov 2009 06:57:59 -0800 (PST)
From: just2ducky1234-1@yahoo.com
Subject: Re: Jiffies jumping with the x86 HPET
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B02AD9B.5040105@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply, now this problem is with customers, so a patch would probably be best. But I was mainly hoping for confirmation of the scenario and the one-liner (one-byte!) fix, since we can cobble something together to implement a patch. Also I wanted to get information out on Google, in case someone else encounters the problem, since there don't seem to be any hits on this.

Regards,
Lee

________________________________
From: Michael Tokarev <mjt@tls.msk.ru>
To: Lee Merrill <lee_merrill@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Sent: Tue, November 17, 2009 9:05:15 AM
Subject: Re: Jiffies jumping with the x86 HPET

Lee Merrill wrote:
> We are seeing jiffies go forward occasionally, by 300 seconds, this it appears is due to the following code in the 2.6.16 kernel:
> 
> mark_offset_tsc_hpet(void):
> ...
> 1       hpet_current = hpet_readl(HPET_COUNTER);
> 2       rdtsc(last_tsc_low, last_tsc_high);
> 3
> 4       /* lost tick compensation */
> 5       offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
> 6       if (unlikely(((offset - hpet_last) > hpet_tick) && (hpet_last != 0))
> 7                                       && detect_lost_ticks) {
> 8               int lost_ticks = (offset - hpet_last) / hpet_tick;
> 9               jiffies_64 += lost_ticks;
> 10      }
> 11      hpet_last = hpet_current;

There is no such code in current (2.6.31 or even 2.6.27.y) kernel.
Both hpet support and timer/clock code received huge changes in
2.6.24+ kernels.  I guess your best bet is to upgrade.

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

