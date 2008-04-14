Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYDNFYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYDNFYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 01:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYDNFYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 01:24:31 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:47474 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752135AbYDNFYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 01:24:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qa3Z3WzDowSQg3+RW250izXaJEq1z+bsTC1fu7WmDzAICaIP1S/xgjKE/6UeH05LzxgQoDpFsEJ5Hsz5h1l/L1aL2bII8rojhXiNGgDydmL4vLnUBuViEWGQWmKZyx8NkMy2d7s97P9ywdlob+/GKKGNDTWuxuLtJq7bOe517mg=  ;
X-YMail-OSG: oVC.JSMVM1kUF8eqZpBfSRoC92S8o7dtmN_hnzWVvv3jRcEX
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] s2ram: warn when interrupts should be disabled but are not
Date: Sun, 13 Apr 2008 22:24:27 -0700
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
References: <20080412095311.GA1729@elf.ucw.cz>
In-Reply-To: <20080412095311.GA1729@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804132224.27792.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Pavel Machek wrote:
> +                                       WARN_ON(!irqs_disabled());
>                                         ret = drv->suspend(sysdev, state);

Wouldn't it be better to assert the warning AFTER the
driver had a chance to screw it up?  (On the resume
side of things too.)

We know IRQs were disabled on entry to the loop.
If something went wrong it was some goofy driver.
Best warn about it ASAP instead of *maybe* getting
a warning before the next driver (if there is one).

And if you're concerned about such issues, I'd think
similar warnings would be done in suspend_late() and
resume_early() support...

- Dave


