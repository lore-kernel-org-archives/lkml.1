Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbYB0CRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbYB0CRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 21:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYB0CRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 21:17:07 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:39979 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752136AbYB0CRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 21:17:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vjon7k00Wtes2kM40JbHvY071YoHWA9JIN2QxOEB8WaQ2CwwFef1CGVEqKGvWSqAfmvKqqvJLVruD2GaW4Ega8T6YcHUbK2HPvyZvl/t9twe2vuUIn6hkygAjH8pBZVtLjBwlq2JP2n1+7vppECKGWzxGqXjkvXJQsv6H65NWo4=  ;
X-YMail-OSG: HVPyEKIVM1m5V8xrJAgM9Y9F_3sMj1w5ohz23CxXxiWvEYF3sORsjh35kYSurlWEnx3Uy0nLFA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       "mahendra varman" <mahendravarman15@gmail.com>
Subject: Re: usb detecting only high speed devices only - not detecting low speed devices
Date: Tue, 26 Feb 2008 18:17:02 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <4ac2955e0802260543n7d7e5d81nb590d2bc10648269@mail.gmail.com> <20080226160538.086a681d.akpm@linux-foundation.org>
In-Reply-To: <20080226160538.086a681d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802261817.02830.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Andrew Morton wrote:
> > usb 3-1: new low speed USB device using ohci_hcd and address 2
> > ohci_hcd 0000:01:04.1: Unlink after no-IRQ?  Controller is probably
> > using the wrong IRQ.

My diagnosis hasn't changed since last time he asked this question:
it's related to IRQ handling, outside the scope of USB.  If USB
were getting the OHCI interrupts, it would not issue that message.

Now as to *why* that happens, I don't know.  We've certainly had folk
using Philips/NXP EHCI controllers successfully before.  Maybe this
board has a hardware problem, like a bad chip or not having wired
up the power lines that OHCI controller uses.

One small experiment would be to try using ports that will hand
the device off to the *other* OHCI controller on that chip.  If
it's that kind of hardware issue, it might not apply to both of
the OHCI controllers.
