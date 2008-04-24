Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYDXNGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYDXNGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYDXNGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:06:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:60560 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYDXNGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QhHAneTE2jUapwXTXgSlZxl3nhRCs6mB6hBbqgB0lrQHSgAR3cv1fsbXPDnu5trKmqZQx2ZUjwsCTaImM3GJbHk+Zspw5CKlNiWzk+/33DtxTtpbCEF9A0kUslkzKlVZjbkoJ7Ntj39d0JV0TFIdCtuggrws0DgDDr5EVCxvlUA=
Message-ID: <18b669d80804240606n47854939x94278f8d974034c1@mail.gmail.com>
Date: Thu, 24 Apr 2008 22:06:11 +0900
From: "Shigeo N" <shigeonx@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: XTP for 2.6.25
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <873apbijb9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
	 <873apbijb9.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I have connected 2 hosts directly, and evaluate the each throughput.
Then all the results of UDP, TCP and XTP are the same and 94Mbps. (My
netwrok is 100Base/TX).

In this case round-trip time between 2 hosts is less than 0.1ms
because they are directly connected. But my previouse case, round-trip
time between 2 hosts are 4ms. (I use IPSEC between the security
gateways to increase delay).
I think that's the reason TCP throughput is slow. If ACK packets are
delayed, sending window cannot slide and sending packets cannot be
fully bursted.

If I changes wmem size through /proc/sys/net/ipv4/tcp_wmem, TCP's
throughput may improve, but congestion control becomes more difficult
for TCP.

That is TCP's disadvantage to XTP.

Best
Shigeo

On 4/24/08, Andi Kleen <andi@firstfloor.org> wrote:
> "Shigeo N" <shigeonx@gmail.com> writes:
> >
> > I tested in the network where UDP throughput is 29Mbps, then TCP
> > throughput was 13Mbps, but XTP's reached to 25Mbps.
>
> One interesting question is why TCP was so much slower than UDP
> on your test. It shouldn't be on a fair test setup.
>
> Please post details. Was the network losing packets?
>
> New protocols might be interesting, but even more interesting is to
> fix any (real) problems in existing protocols.
>
> -Andi
>
