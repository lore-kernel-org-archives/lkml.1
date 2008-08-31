Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYHaGlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYHaGlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 02:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHaGlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 02:41:02 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:8420 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYHaGlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 02:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lio/eEWv9B/gbKQp7gnPq8qT//a6Y0jpvPSoEj+HX+c7WcS+FSCmWJtVv8xjfVr4hf
         Iz4uWTzuniPxQw7Bc/FldgGFo7VMEOx4x/SpbsfvQ9FrdXNUCcixZh8QU4iVIPm1qeK6
         iMdOKKw2AaGsFlYVmKRep8I9DddNHjnuQep04=
Message-ID: <21d7e9970808302340w71483645macb34f8470a85c66@mail.gmail.com>
Date: Sun, 31 Aug 2008 16:40:59 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808302219.45103.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <898503EB1E15BA4F944D1BE69D55AAC8AB540A@storexmb1.amd.com>
	 <200808302219.45103.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 12:19 PM, Gene Heskett <gene.heskett@verizon.net> wrote:
> On Saturday 30 August 2008, Bridgman, John wrote:
>>))I'm drowning in these errors:
>>))
>>))Aug 30 13:21:05 coyote kernel: [14927.850078] [drm] wait for fifo failed
>> status : 0x80076100 0x00000000
>>
>>I'm just going on the code in your email - can't view git until later today
>> - but in this case it seems like the timeouts were always happening and now
>> there is code to print an error message.
>>
>>IIRC the usual fix is to bump the timeout but (Michael ?) has suggested a
>> couple of times that the ideal solution would be to change the logic so
>> that the driver never times out while the chip is making progress (ie while
>> the number of slots available in the fifo is increasing, even if it hasn't
>> increased enough yet).
>>
> FWIW, I added the 3 lines that cause that printout to the 2.6.27-rc4 tree and
> rebuilt it.  There are no more errors being reported now by 2.6.27-rc4, and
> there were none without those 3 added lines prior to this, so it is rc5
> specific.

Hmm I'm just looking at the patches I put in for rc5, and there is no
functional difference to the
r200 codepath that I can see from those patches apart from the debug prints.

Can you get a clean -rc4 and apply just 54f961a628b737f66710eca0b0d95346645dd33e
to it.

See if you can get that to produce the errors, if it does, apply just
the drm info chunks, try again, if that works, try adding
the isync cntl chunk. and re-testing. I can't see how writing isync
cntl here would affect things though.

Dave.
