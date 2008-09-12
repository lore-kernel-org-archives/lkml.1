Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYILC6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYILC6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYILC6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:58:25 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64951 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756784AbYILC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:58:24 -0400
Message-ID: <48C9DACE.5040308@lwfinger.net>
Date: Thu, 11 Sep 2008 21:58:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
References: <48C9D040.8010107@lwfinger.net> <f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com>
In-Reply-To: <f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> On Thu, Sep 11, 2008 at 7:13 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> In file drivers/net/wireless/p54/p54common.c, the statement
>>
>>       priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);
>>
>> generates the sparse warning
>>
>> .../p54common.c:185:29: warning: cast to restricted __le16
>>
>> where bootrec->data is u32, and priv->rx_mtu is u16.
>>
> 
> (Whoops, didn't CC the mailing lists. Sorry about the double-message, Larry.)
> 
> If priv->rx_mtu is u16, I'm surprised it doesn't get noisy about the
> size_t cast. Unless the machine it's being compiled on is 16-bit, that
> should throw a truncation warning, because size_t should be a 32-bit
> integer on 32-bit machines (typically).
> 
> I think if you change the (__le16) cast to (__le16 __force) it will
> stop warning you about that particular issue.

This one gets rid of the sparse warning.

        priv->rx_mtu = le16_to_cpu((__le16 __force)
                                   bootrec->data[10]);

Thanks,

Larry
