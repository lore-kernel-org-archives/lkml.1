Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYFARgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYFARgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 13:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYFARgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 13:36:03 -0400
Received: from jabberwock.ucw.cz ([89.250.246.4]:36476 "EHLO jabberwock.ucw.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYFARgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 13:36:02 -0400
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 13:36:02 EDT
Date: Sun, 1 Jun 2008 19:05:05 +0200
From: Martin Mares <mj@ucw.cz>
To: Jiri Hladky <hladky.jiri@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug in arch/i386/lib/delay.c file, delay_loop function
Message-ID: <mj+md-20080601.170340.5225.albireo@ucw.cz>
References: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> when trying to understand how Bogomips are implemented I have found
> bug in arch/i386/lib/delay.c file, delay_loop function
[...]

> The function fails for loops > 2^31+1. It because SF is set when dec
> returns numbers > 2^31
> 
> The fix is to use jnz instruction instead of jns (and add one decl
> instruction to the end to have exactly the same number of loops as in
> original version):

It is a long time since I have hacked that file, but you should definitely
make sure that the function is never called with a zero argument. In such
case, the original version made just a single pass, but your version
makes 2^32 of them.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Homo homini lupus, frater fratri lupior, bohemus bohemo lupissimus.
