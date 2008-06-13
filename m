Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYFMUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYFMUny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 16:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYFMUno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 16:43:44 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:41631 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753274AbYFMUnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 16:43:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z5tD7FRHdQUpq/xUzTTqtBiOb+ESxYQpCLRG7b/xM1elEWILy5YJyiH437V9k9X40R87oEw0oHHUMyI1Sx8JxFBeuV3FTZD31SEzoE1vdnq6XeGifLNr+bZFPUU7ERs+r6xoqasc5S19usrQx/Y3+B8z4qE8t1jjWg9R+mnHJMg=  ;
X-YMail-OSG: VHjMuMwVM1k2A3NyI_BHlLHQhfwynMS4wKOuUcNk8p8vgB9Zo28QNVy23Hic2zp3E2TqU63oVaZ_qNyBzLVj6.t87w4bOiu_PYuLEh_GBg2LfmipIGXVTc55plB0MK6uvLE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Lior Dotan" <liodot@gmail.com>
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Date: Fri, 13 Jun 2008 13:43:41 -0700
User-Agent: KMail/1.9.9
Cc: "Adrian Bunk" <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       a.zummo@towertech.it,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <20080613193302.GA1716@cs181133002.pp.htv.fi> <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
In-Reply-To: <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131343.41213.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008, Lior Dotan wrote:
> I don't know if it helps you to decide but the way I got to this
> configuration is by copying my working 2.6.25 .config file and running
> make oldconfig. I think this scenario is common when upgrading to a
> newer version so you should make sure it doesn't generate an invalid
> configuration.

It doesn't!  "No /dev/rtc" is a perfectly valid config.  And it's
not uncommon that new kernels require config tweaks.

To repeat what's in the bug database:  your old config didn't use
one of the valid RTC configs:  legacy *OR* new style (else neither).

Mixing the two was never supported ... it caused various bugs, and
much confusion.  You might not have observed with your old .config
on your hardware (or might have ignored it), but other folk did.

I'm not sure anyone would have wanted to merge any patches that
would have let the two frameworks coexist/overlap, but that's a
moot point since nobody (including you) submitted such patches.
What was submitted was a patch that rejected an invalid config.

- Dave
