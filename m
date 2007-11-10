Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXKJNDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXKJNDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 08:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXKJNC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 08:02:58 -0500
Received: from bravo667.server4you.de ([85.25.132.126]:37192 "EHLO
	mail.sitenet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbXKJNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 08:02:57 -0500
Message-ID: <4735AC13.9030206@czajsoft.pl>
Date: Sat, 10 Nov 2007 14:03:15 +0100
From: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org,
       linux-cifs-client@lists.samba.org
Subject: Re: Fw: Buffer overflow in CIFS VFS.
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com>	 <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>	 <47343DA2.90306@czajsoft.pl> <524f69650711091444t4d02e6d8g7dd15dbe2637d714@mail.gmail.com>
In-Reply-To: <524f69650711091444t4d02e6d8g7dd15dbe2637d714@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> below.   The obvious need is to create an SendReceive-NoResponse (or
> equivalent) which
> frees the SMB request buffer after send, and does not copy into an smb
> response buffer.  The following functions need to be changed to use
>   
How about modifying SendReceive to behave like that if NULL is passed as
output buffer ?

>> Obviously it is up to you, as a maintainer. I'd prefer adding a small
>> header to each buffer with the buffer size and perhaps a type, or even a
>> destructor function pointer. Simple macros could be used to obtain
>> buffer size, given the buffer body pointer, or to dispose the buffer.
>> That would save from checking the buffer type all over the code
>> explicitly, or even worse, make strange assumptions about the type of
>> buffer being passed - as we can see this is error-prone. That for a
>> little cost of a few additional bytes per buffer.
>>     
> That might be better, although without memory pools, this would perform
> much worse
>   
Why ? I don't get your point here.

Przemyslaw

