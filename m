Return-Path: <linux-kernel-owner+w=401wt.eu-S1765452AbYBTVZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765452AbYBTVZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765580AbYBTVYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:24:43 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:37329 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933772AbYBTVYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:24:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5+t82vknHP4LQM+ChdOLF2qjGBwarWxFOj67Xwy0hdDvf0z1Hi67ANfEftSY1qgtGqGxzDO8U1Ii86xryyzJNItReMEwIWVb3a0H7SW/Q0H2hYNe++9ioRX/CE0QF6rI3hCiAmyPVO+VYku1FJcYa0ptux3uoUAcAR80jAO7dMI=  ;
X-YMail-OSG: d2fOs6oVM1nqO7_AZNSXxgEynEohz6G.O1qcITgV06xQqRrYxcv7iVap9jhJV6sWoaqCAkT5.Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andre Tomt <andre@tomt.net>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Wed, 20 Feb 2008 13:24:36 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <47BAF36C.4000509@tomt.net> <200802191632.35732.david-b@pacbell.net> <47BC8E9D.8080309@tomt.net>
In-Reply-To: <47BC8E9D.8080309@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201324.37519.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Andre Tomt wrote:
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021

... etc.

OK, the relevant bits are:

   status  0001 == some transaction completed normally (ignored here)
   status  0020 == IAA set, which should have triggered an IRQ
   command 0040 == IAAD clear, meaning IAA should have triggered

Meaning the hardware is misbehaving in a "traditional" way, one
that the watchdog is supposed to catch:  IAA set, but no IRQ.

If you see any "IAA" messages *other* than those, please report
them ASAP.  They'll indicate "nontraditional" misbehavior.


> It has not crashed yet with the patch though.

It seems that one of the tweks in this patch made the watchdog
act better than before.  So unless I hear from you (before the
start of next week) that some other message appears, or that your
oops re-appears, I'll submit some version of this patch for RC3.

And if you're up for it, I may have another patch for you
to try on top of this one ... I had an idea about IRQ trigger
modes that might be causing this problem.

- Dave
