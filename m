Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYHQL6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYHQL6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 07:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYHQL6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 07:58:03 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39660 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbYHQL6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 07:58:02 -0400
Message-Id: <1218974280.18151.1269040199@webmail.messagingengine.com>
X-Sasl-Enc: z+kl5+iRgWWg2zQNvGCmekdua+AUjbyNcYhn9s4EAmjH 1218974280
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: oakad@yahoo.com,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <865989.50481.qm@web37602.mail.mud.yahoo.com>
Subject: Re: Problem with find_first_bit function and kin
In-Reply-To: <865989.50481.qm@web37602.mail.mud.yahoo.com>
Date: Sun, 17 Aug 2008 13:58:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 12:26:54 -0700 (PDT), "Alex Dubov" <oakad@yahoo.com>
said:
> It's well may be that I'm just missing something obvious.
> 
> It seems to me that find_first_bit/find_next_bit functions return their
> offsets "base 1" - first set bit is "1" and last is "bitmap size". This
> means that if only the last bit in the bitmap is set, the returned value
> will be indistinguishable from no bits set situation. Moreover, bit
> manipulation functions appear to use "base 0" bit addresses, adding to
> the
> inconvenience.
> 
> Is this a desired behavior? And, if yes, how is one supposed to deal with
> last bit of the bitmap?

Hi Alex,

If this is the behaviour you observe, it's a bug. How did you
find out?

The intended behaviour is that the bits are enumerated in "base 0"
style. If only the last bit in the bitmap is set it should return
bitmapsize-1 and if no bit is set it should return bitmapsize.
Some architecture-specific code gets the last detail wrong, they
return a value that is slightly larger than the bitmap size in
some cases.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

