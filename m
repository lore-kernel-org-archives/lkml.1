Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZCQSBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZCQSBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZCQSBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:01:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:40956 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZCQSBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=thjqXJ66P+nuxFjEDz6GUPIt8E2jPTXNKb1hs5vX0vTrLh3x1tnYeGxIYFDekkww5N
         /Pr2hjNXe3Sv7Z/9kkr00Phe3k/xCBuVmqDuXoRSaDAfYqXoAAKS3Ir/J7svtjF6fLIQ
         yIdtGp2vMTH1GTpJVimmbdH1fvL9PW8lCAHlg=
MIME-Version: 1.0
In-Reply-To: <20090317085714.54bcd51c@lxorguk.ukuu.org.uk>
References: <bc9165390903160912u79693a1dve975f559bfab103e@mail.gmail.com>
	 <bc9165390903162233o48e02d94v6bb216e5d68d9e77@mail.gmail.com>
	 <bc9165390903162234maedd4d0l7026d8f53a1859cc@mail.gmail.com>
	 <20090317085714.54bcd51c@lxorguk.ukuu.org.uk>
Date: Tue, 17 Mar 2009 23:31:20 +0530
Message-ID: <bc9165390903171101s454838bci158ee1c32134af74@mail.gmail.com>
Subject: Re: Serial Flow Control
From: Rocker Dude <life.does.rock@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you very much for the prompt reply!

I debugged out the problem though. I will describe it, even if it
seems childish!

I was using the flow control on the console serial. As a result, any
data being sent to the powerpc from the x86 was also being read by the
console driver, and being responded to. As a result, many of times, my
actual serial read application would lose bytes and sit idle. I
changed the console port and observed data validity perfectly.

However, I have some few queires.

1. To prove flow control, I sleep for 5 seconds after every read.
Although my logic says that both the xmitter and the reciever in this
case should complete the process within a few time difference, I find
that my xmitter exits out after sending the chunk; while my receiver
keeps on receiving it for a few more time. And this time is almost a
minute or something. I did find out the xmitter 4K page buffers, but
it was too misleading for me to believe this!

Alan, I will once again go through the discipline drivers more before
I shoot may doubts!

Thanx a lot for the help and replies,

Thanx!
Sundar

On Tue, Mar 17, 2009 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 17 Mar 2009 11:04:36 +0530
> Rocker Dude <life.does.rock@gmail.com> wrote:
>
>> Hi All,
>>
>> I am using a powerpc8548e custom hardware and testing flow control on
>> it. I have cross-wired the RTS/CTS of the board with my host terminal.
>> I find that when I am reading from the powerpc, it does not change the
>> CTS signal when it is running out of buffers and hence it is dropping
>> bytes.
>>
>> I referred to something similar at http://lkml.org/lkml/2007/7/26/46.
>>
>> Can anyone please tell me if this flow control needs to be done by the SW?
>
> Flow control needs to be enabled by the user space software (if not
> enabled already), managed by the line discipline and implemented by the
> device driver (or automatically in hardware in some cases)
>
> Basically; App "set CRTSCTS"
> Ldisc: buffers full/not full logic for throttling
> Driver: throttling events -> flow control, honour flow on write
>
