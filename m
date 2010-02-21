Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0BUPuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 10:50:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:43873 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0BUPui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 10:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vp9i/k2Rq7TMMl47mcVjEIph/TtMFPgZEE+vxT9rcZ0SC3UgD5wlW8yda18A9vMpJV
         SFscfr28iZnBQO91/bcoqFJAM7rAEBhADtyVr/OnOindRUb7HnIEUdYO9F4lkcaIPYj2
         HQ1AcjQXpdrOe137+0zad3Cq2aBFwdffIjVSM=
MIME-Version: 1.0
In-Reply-To: <4B814AB3.1030404@shipmail.org>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <4B814AB3.1030404@shipmail.org>
Date: Sun, 21 Feb 2010 16:50:36 +0100
Message-ID: <b170af451002210750i33221b3egc0bb940eac7191f5@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 21 lutego 2010 16:01 użytkownik Thomas Hellstrom
<thomas@shipmail.org> napisał:
> Rafał Miłecki wrote:
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> We try to implement some PM in radeon KMS and we need to sync with VLBANK
>> for
>> reclocking engine/memory. The easiest and cleanest way seems to be
>> sleeping in
>> timer handler just before reclocking. Then our IRQ handler calls wake_up
>> and we
>> continue reclocking.
>>
>> As you see our sleeping is condition-less, we just wait for waking up
>> queue.
>>
>> We hope this waking will happen from IRQ handler, but for less-happy case
>> we
>> also use some timeout (this will probably cause some single corruption,
>> but
>> we can live with it).
>>
>> Following macro is soemthing that seems to work fine for us, but instead
>> introducing this to radeon KMS only, I'd like to propose adding this to
>> whole
>> wait.h. Do you this it's something we should place there? Can someone take
>> this
>> patch for me? Or maybe you find this rather useless and we should keep
>> this
>> marco locally?
>
> What about msleep_interruptible in <linux/delay.h> ?

I guess this will wake up on every signal pending to driver's process.
I need to wake up using my own (VBLANK related) workqueue.

Is that right? Or maybe there is some hack/sth that will let me
achieve what I need?

-- 
Rafał
