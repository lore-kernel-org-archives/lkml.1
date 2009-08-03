Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZHCPdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZHCPdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZHCPdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:33:52 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62127 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbZHCPdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YberQdyAwMeSUtn1IJn/7iGd90cTlCuH8alBGGIzRz4GJW05Yr5yvPAbSzw9Lz4iKt
         bjznnVSdhLv/I0Z1rKybBlAGS14ZZ9xPr7WUYneQtcJncxYE4+1bsej8vtuH8PJ7KbYr
         4bIIs6eBB6qwkaw4NCZqlTH382rtld0aacZmA=
Message-ID: <4A77035C.5090906@gmail.com>
Date: Mon, 03 Aug 2009 17:33:48 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: reading errors on JMicron JM20337 USB-SATA
References: <Pine.LNX.4.44L0.0908031021370.16132-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908031021370.16132-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 3 Aug 2009, Lev A. Melnikovsky wrote:
>> AS> yes, jmicron bridges do not report errors properly and just stall pretty
>> AS> much indefinitely; found out the hard way, when a disk started to develop
>> My interpretation was different - the bridge firmware does not crash but 
>> remains alive (it does not report the error properly but "zis iz probably 
>> perfectly normal behaviour for a Vogon"). This is the Linux kernel that 
>> indefinitely tries to re-read. Am I wrong?

No, but that's arguably the right thing to do -- the device didn't
report an error, so why should the kernel fail?..

> You are correct except for the term "indefinitely".  The retries _will_
> stop if you wait long enough.  Unfortunately, because of all the nested
> retry loops in the SCSI drivers and at the application level, you may
> have to wait as long as half an hour.

iirc, i had stalls _way_ longer than that, probably because the reads
eventually succeeded, only to stall on the next ones.

> I agree that this should be fixed.  But it is a SCSI issue, not a USB 
> issue.  You could try bringing it up on the linux-scsi mailing list.

actually, the number of retries should probably be configurable, but i
wouldn't lower them by default; losing data because of recoverable errors
is bad. In this case the bridge may be at fault (by not passing along the
error), but to make a significant difference you'd have to reduce the number
of retries to something like zero, maybe one at most, and that's just too
low for a default. 

artur
