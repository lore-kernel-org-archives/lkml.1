Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZFXXnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZFXXnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZFXXnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:43:47 -0400
Received: from n22b.bullet.mail.mud.yahoo.com ([68.142.206.159]:26086 "HELO
	n22b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753395AbZFXXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:43:47 -0400
X-Yahoo-Newman-Id: 346646.28251.bm@omp425.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nYmSKVgQ9BMSjR34RMoc8cp9Yrd9JJQzRPd9BgtSPhek5cMYxe6H5cp4X+nEv4TglcjikzwrFsVzNhCZilpgGfHPguKTOeJiNjKm3Euhk4EXwPyyf8W44p7pK/9Brzddi92u82Az8skkjIGohGoPtDOgoCviTb2OwL9rDiwaF8Q=  ;
X-YMail-OSG: YyyxbQYVM1mBD1BpaCCYye5vEPYMpzldFP3NbOmedGSeZilRq3NKqANBY_mhHEwzISENK89mFC2wFfiwdc.OV6lYNiox1NhMZQWP5mowJvDQrvh1P81FT0WOtMm3hBW6gzOdLPpcBUnQA5Vgae5O8g7P46VEzVEhJ4_.IIkfMQ8NQA4Cn8Whc66LzAvYVzXV168R_tIFoKEEirho0ybXJxq.agrF5AwAM6e8VVcZkKX0Z8FDWUTieQ9c5yD98BM078JHTyLddQpozU.KYO41LxYmMnCmU8yi06HHDDuAyD7ieq9_No0C
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Wed, 24 Jun 2009 16:43:48 -0700
User-Agent: KMail/1.9.10
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <200906240149.41013.david-b@pacbell.net> <003b01c9f4b6$c39002b0$4ab00810$%szyprowski@samsung.com>
In-Reply-To: <003b01c9f4b6$c39002b0$4ab00810$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906241643.48421.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Marek Szyprowski wrote:
> 
> > So it's looking like tty->driver_data is somehow NULL.  That's
> > never supposed to happen.  Did gs_open() fail or something?
> 
> I've triggered this bug by running a 'getty -L 115200 ttyGS0 vt100' and trying
> to login on that usb console and then pressing 'enter' key for longer time.
> getty might abort after a few failed logins, so the /dev/ttyGS0 file might be
> closed before all characters that need to be echoed were processed (usb udc debug
> messages really slows it down). This is however a pure guessing, I know nothing
> about tty framework and internals.

Hmm, that would mean the shutdown processing isn't behaving
right.  Plausible, it's tricky to test.

Patches accepted.  ;)



