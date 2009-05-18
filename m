Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZERORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZERORP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZEROQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:16:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:56945 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753306AbZEROQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:16:48 -0400
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX18NOLBfOs8N8A08KHaM8eoQe6iGIT2XylTDTaDZLy
	MDXi8cIgX/xNup
Date: Mon, 18 May 2009 16:16:46 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org
Subject: Re: s2disk hangs with kernel >=2.6.29, SATA, Gigabyte EG45M-DS2H
	(bisected)
Message-ID: <20090518141646.GA6460@arbonne.lan>
Mail-Followup-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org
References: <20090516225153.GA7883@arbonne.lan> <200905180117.28413.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905180117.28413.bzolnier@gmail.com>
Mail-Copies-To: nobody
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 01:17:27AM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 17 May 2009 00:51:53 Richard Atterer wrote:
> > The patch that causes the hang is 295f00042aaf6b553b5f37348f89bab463d4a469:
> > ide: don't execute the next queued command from the hard-IRQ context (v2)
> 
> Hmm, this should have been fixed by:
> 
> commit 2ea5521022ac8f4f528dcbae02668e02a3501a5a
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Wed Jan 14 19:19:04 2009 +0100
> 
>     ide: fix suspend regression

I just tried that revision (with a small patch to get pcf50633-core to 
compile) and hibernating does not work. :-/

> What was the last 'good' kernel that you've started bisection with?

I started with the 2.6.28 release.

In case it makes a difference: The swap partition that I'm hibernating to 
is encrypted via luks and uses lvm. This is the standard way suggested by 
the Debian installer when you choose encryption.

Cheers,

  Richard

PS: This is my /etc/uswsusp.conf file:
resume device = /dev/mapper/pc-swap
splash = n
compress = y
early writeout = y
image size = 1897884221
RSA key file = /etc/uswsusp.key         <-- that file does not exist
shutdown method = platform
-- 
  __   _
  |_) /|  Richard Atterer     |  GnuPG key: 888354F7
  | \/¯|  http://atterer.net  |  08A9 7B7D 3D13 3EF2 3D25  D157 79E6 F6DC 8883 54F7
  ¯ '` ¯
