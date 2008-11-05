Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKEGbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKEGbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 01:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYKEGbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 01:31:14 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3503 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbYKEGbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 01:31:13 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Michael Chan" <mchan@broadcom.com>
To: "'David Miller'" <davem@davemloft.net>
cc: "linux-kernel@blueteddy.net" <linux-kernel@blueteddy.net>,
       "daniel.blueman@gmail.com" <daniel.blueman@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>
Date: Tue, 4 Nov 2008 22:31:00 -0800
Subject: Re: time for TCP ECN defaulting to on?
Thread-Topic: time for TCP ECN defaulting to on?
Thread-Index: Ack/C6LrNVSi8rKlSf+1crou6Oh01wAAs68A
Message-ID: <C27F8246C663564A84BB7AB343977242151F4B18B4@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20081104.215839.132524253.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
acceptlanguage: en-US
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Nov 2008 06:31:01.0003 (UTC)
 FILETIME=[11F475B0:01C93F10]
X-WSS-ID: 650FE22F37G9027923-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: "Michael Chan" <mchan@broadcom.com>
> Date: Tue, 04 Nov 2008 17:16:03 -0800
>
> > I think this is no longer a limitation.  The GSO code will take care
> > of ECN properly if the hardware does not support it when doing TSO.
>
> Hmm, good point, but if that is what happens I don't know if I agree
> with it.
>
> If "take care of ECN" means doing TSO in software, that's in my
> opinion the wrong thing to do.
>
Right, it means TSO will be done in software by the GSO code if
ECE or CWR is set in a TSO frame and the driver indicates that
the hardware cannot segment such packets properly.

This allows TSO and ECN to coexist.  Before this, ECN was always
disabled when TSO was enabled.

Assuming ECE and CWR are set infrequently on TSO frames, we still
benefit from hardware TSO most of the time.  Why is it the wrong
thing to do?


