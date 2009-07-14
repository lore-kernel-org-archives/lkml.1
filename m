Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZGNLFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZGNLFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZGNLFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:05:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34265 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZGNLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=whxsW9CuzivJbcV1efCoT8KtQLVI4xhWlevxExiKbN1gPYs+k3vhnVHkLOwACZ+uBd
         s+PJVnrMA0QPLsKuoi4ZsPQTYgP4A0YYHyS53AxwokOVh8bdZWsw7x/FtHVOr5HDRH57
         MuuVABu/GzjZt4EzUYCLciNQ05V1vlKgvwfrE=
MIME-Version: 1.0
In-Reply-To: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
Date: Tue, 14 Jul 2009 12:04:56 +0100
Message-ID: <c6b1100b0907140404h4fdbe419p8443da43350f3520@mail.gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,


2009/7/13 Chris Clayton <chris2553@googlemail.com>:
> Hi,
>
> Please cc me on any reply because I'm not subscribed.
>
> I've been testing 2.6.31 development kernels on my laptop and find
> that I can induce a complete lock-up more or less at will. To do so,
> all I have to do is generate some network traffic on my wireless LAN
> (I've been using wget to transfer a file from another box on my LAN)
> and then wait. If I run netstat repeatedly while waiting, I see a TCP
> connection to port 21 on another box on my LAN in a TIME_WAIT state.
> It seems that when that connection disappears, the laptop locks up
> hard and I can only recover by powering off and on again. I think the
> problem is related to the rt61pci driver because I haven't been able
> to induce the lock-up when using a wireless card that's supported by
> the ath5k driver. I started bisecting, but a couple of times I arrived
> at points where although the kernel builds OK, I have no network
> connectivity. I guessed at good, but the bisection process finished at
> a change that can't be the culprit (because it's for a different
> architecture).
>
> I attach the best diagnostics I can think of at this point in time
> (but am more than happy to provide any others that are requested). It
> includes the output from dmesg from a boot that locked up and the
> syslog journal from that boot; a description of the wireless card from
> lspci -v and the output from netstat that shows the connection I think
> is involved. As I say, feel free to ask for any other diagnostics that
> will help track the problem down.
>
> I have confirmed that the problem is still present in a kernel built
> after a 'git pull' this morning, although it was somewhere around the
> time that -rc2 was released that I first came across it. I cannot
> induce the problem with 2.6.30.1.

I've updated to 2.6.31-rc3 this morning and done some more testing.
I'm now convinced that the rt61pci driver is somehow involved in
locking up the laptop. With the (Belkin) rt61 card inserted, the
machine will lock up even if I am doing nothing (no web browsing,
email or anything else at all) except running this script in a console
window:

i=0
while true; do
        let i++
        echo -n "$i "
        sleep 1
done

In the tests I have done so far, the counter has never gone beyond 240
before the machine locked. With the (no-name) ath5k card inserted I
can use the laptop for normal web browsing, email, etc with no
problems - the counter in the script above gets to over 2000.

As I said yesterday, I'm happy to provide additional diagnostics,
apply patches, etc.

Thanks

Chris
-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
