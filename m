Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYEPLo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYEPLo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYEPLot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:44:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:33729 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYEPLos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DbM1NJeUagbqPnCpqH17PGEUzRpttd3QYBV5eNPDFsZlZkat2Yjzfkx9/iXvcLtmGLDFk8BwxmzR0Yig6lSs6VpTrvCnhyeffz5Q3dTO4k/fnO6T7B2CtKzyMhgIEbzuVNB4aUiHwyG68fwEeuMnpncF2aFLUvnJ6F7Z/IEzENA=
Message-ID: <38b2ab8a0805160444w1a982cffw94ba91b30f5c2aac@mail.gmail.com>
Date: Fri, 16 May 2008 13:44:47 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: How to avoid data copies in a driver ?
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <482D416B.8060501@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
	 <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com>
	 <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
	 <482D416B.8060501@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 16, 2008 at 10:10 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Francis Moreau wrote:
>>
>> I'm suprised because what I need doens't seem so uncommon, usually
>> devices send or
>> receive data to/from files. So a helper (system call ?) to achieve
>> that other than the basic
>> read/write seems needed, no ?
>>
>
> It's fairly rare to have an application which requires moving data to file
> with absolutely no processing; normally there's at least a bit of
> massaging/parsing/etc.

Well, every cases where a client <-> server exchange files. I wouldn't call
that a rare case...

> If that's really what you want to do, maybe you can
> do it with splice?  I haven't looked at it at all, but the intention is that
> you can splice file descriptors together, so you can splice your device fd
> to a file fd and have it all just work...
>

yes but the kernel I'm working on (2.6.16) doens't have splice support.

But relay may sound a good idea, and the version I use has sendfile support.

The drawback of relay: the user application can receive a file from the kernel
but the app can't send a file to the kernel.

But I can be wrong since I haven't look at relay closely yet.

> Alternatively you could read() from your device into a mmaped file.  That's
> a single copy from device to file, which is about the best you can do
> without going to heroic lengths.
>

Don't know for now.

I think using sendfile with relay may be a good answer without me becoming
a hero ;)

> Also, it really depends on your application.  Is it a high-bandwidth thing
> in which the copy is a huge cost?  Or do you want to eliminate the copies
> because it seems like a nice thing to do?

No it has a real cost. The application receives files which are usually larger
than 1Go.

Thanks
-- 
Francis
