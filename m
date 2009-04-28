Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZD1UcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZD1UcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZD1Ubu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:31:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54901 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZD1Ubt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JOznjUBsMyjt7P2y9T7tWxad5vzSVQBSVbOWexigxpKJg53Xq48EzI5wabkK/2ps9H
         VEKd15xN22B+S6XFT2PoaOIjVnG4H2Z08/90lLLBLiPikF8Dqf0LRL7vmlvzVOWhHC4s
         rU0yt5AA4lT4rS9331SXaw4I9fZ+DQ95KVqv4=
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Peter Feuerer <peter@piie.net>
Cc: petkovbb@gmail.com, LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <cone.1240949852.549814.7466.1000@mentalhome>
References: <cone.1240623959.159615.9486.1000@mentalhome>
	 <cone.1240648971.372002.7492.1000@mentalhome>
	 <20090426172947.GB3643@liondog.tnic>
	 <cone.1240858632.795110.5316.1000@onepiie>
	 <20090428072519.GA12170@liondog.tnic>
	 <1240913055.29860.14.camel@maxim-laptop>
	 <cone.1240949852.549814.7466.1000@mentalhome>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Apr 2009 23:31:44 +0300
Message-Id: <1240950704.3781.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 22:17 +0200, Peter Feuerer wrote:
> Hi Maxim,
> 
> >> Their N270 datasheet
> >> (http://download.intel.com/design/processor/datashts/320032.pdf) talks
> >> about max Tj (junction temperature) being 90°C for a TDP of 2.5W and if
> >> you operate below that limit "functionality and long-term reliability
> >> can be expected." :)
> >> 
> >> There's also an internal termtrip sensor which is designed to go off at
> >> Tj=125°C so, yeah, I guess something 70°C should be ok.
> > 
> > I have small note:
> > 
> > So yes cpu can withstand 90 C, but will rest of the motherboard?
> > 
> > (Most other cpus are rated at 60C)
> 
> That's why the module is started in "user mode" where the bios controls the 
> fan. - The Bios just starts the fan as soon as the temperature is higher 
> than 40 degree celsius.
> 
> The user must explicitely start "kernel mode" to make the kernel 
> controlling the fan. Maybe we should add a warning somewhere, that it could 
> harm the hardware?
Then its fine.

(I probably won't turn fan off though).

I have a aspire one, so I install this driver.
one more note thought, you might want to rename it to something else,
or maybe merge with acer-wmi?

If I understand correctly, this driver also provides temperature
reading, which is in my opinion very nice.
Thus, this seems more a 'acer aspire extras'

Or, maybe even better, maybe you can name it a 'EC extra driver', since
today many notebooks are controlled via EC, and thus you or other
contributors might add more features to this driver.
How about a EC register dump for example in /sys, so users could look at
EC registers comfortably

But of course, I think this driver should first be merged.

Another small note, is would be very nice to have a locking mechanism
for EC reads/writes, so there would be no conflicts between accesses.

For example my main notebook, acer 5720, has semi broken fan control
(they broke it in newer bioses, but I have to use them, because fan
won't work at all in 64-bit OS I use (linux of course).

There is a way to control the fan, by writing fake temperatures to EC
and doing that very often, since I think SMI writes there too.
But when I do so, ofnen other EC related things fail, like brightness
control for example. I think this is due to the fact that acer_ec does
direct I/O.

so I would like to see a interface to read/write EC properly.

Best regards, and thanks,
	Maxim Levitsky



