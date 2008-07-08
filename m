Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYGHNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYGHNu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYGHNuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:50:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:19352 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYGHNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=A7wvnN6qoAlRHqnrNMIYeSL2MfbqNlsFJjx61wNVsPXKApjB5ZPeJNY5plFB6A8I7w
         MoS4mrzDoRx3R0+/HHqKdaIpZqUNjlf+w3WANf1Jx/gnpohkUimHzQk2pJ1jt9OuS4FM
         JP8j0JrXKZElJedLp/wcdP51uZlhbSYpknOaU=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc (fwd)
Date: Tue, 8 Jul 2008 15:58:20 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080620175729.GA3151@ime.usp.br> <200806292051.56596.IvDoorn@gmail.com> <20080708035512.GA550@ime.usp.br>
In-Reply-To: <20080708035512.GA550@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081558.20365.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you try some of the following tests to control the registers:
I have grouped each test together, please don't do them all in one single shot,
since that will not help narrowing down the exact register which breaks everything.

> > 11 :0x0005                                                    | 11 :0x000a	MAC_CSR11: SIFS.
> > 12 :0x016c                                                    | 12 :0x013a	MAC_CSR12: EIFS.

echo 11 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
echo 5 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
echo 12 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
echo 364 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value

---

> > 33 :0xb11a                                                    | 33 :0xb162	TXRX_CSR1: TX configuration.

echo 33 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
echo 45338 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value

---

> > 42 :0x000e                                                    | 42 :0x000a	TXRX_CSR10: Auto responder control.
> > 43 :0x015f                                                    | 43 :0x0000	TXRX_CSR11: Auto responder basic rate.

echo 42 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
echo 14 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value
echo 43 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_offset
echo 351 > /<debugfsroot>/<mac80211>/rt2500usb/register/csr_value

---

> > 2 :0x1e                                                       | 2 :0x06	R2: TX antenna control

echo 2 > /<debugfsroot>/<mac80211>/rt2500usb/register/bbp_offset
echo 30 > /<debugfsroot>/<mac80211>/rt2500usb/register/bbp_value

Ivo
