Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYEPIKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYEPIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYEPIKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:10:34 -0400
Received: from gw.goop.org ([64.81.55.164]:41633 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYEPIKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:10:33 -0400
Message-ID: <482D416B.8060501@goop.org>
Date: Fri, 16 May 2008 09:10:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to avoid data copies in a driver ?
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>	 <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com> <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
In-Reply-To: <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> I'm suprised because what I need doens't seem so uncommon, usually
> devices send or
> receive data to/from files. So a helper (system call ?) to achieve
> that other than the basic
> read/write seems needed, no ?
>   

It's fairly rare to have an application which requires moving data to 
file with absolutely no processing; normally there's at least a bit of 
massaging/parsing/etc.  If that's really what you want to do, maybe you 
can do it with splice?  I haven't looked at it at all, but the intention 
is that you can splice file descriptors together, so you can splice your 
device fd to a file fd and have it all just work...

Alternatively you could read() from your device into a mmaped file.  
That's a single copy from device to file, which is about the best you 
can do without going to heroic lengths.

Also, it really depends on your application.  Is it a high-bandwidth 
thing in which the copy is a huge cost?  Or do you want to eliminate the 
copies because it seems like a nice thing to do?


    J
