Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbXJIEdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbXJIEdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXJIEdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:33:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:49711 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXJIEdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j7/iTJKbZSEeu0Xz2JTLByZs6Z/W3LylD9Z04uMVlrETb5dLtkAr4saJM3oH8a6R+Ic/+YJw/So9gofAmBeE1Oo5JePRQwanzVUJs9WQeQ91Xg+kCmQXWJR3w69EZQ3dGq3Vw7Za1K/AQCuzY8KXW5vXcjdVZ0cJX/8LIlaZd2Y=
Subject: Re: sleepy linux 2.6.23-rc9
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: tglx@linutronix.de, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071008220506.GE3484@elf.ucw.cz>
References: <20071008220506.GE3484@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 12:33:33 +0800
Message-Id: <1191904413.6083.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 00:05 +0200, Pavel Machek wrote:
> Hi!
> 
> I played with powertop a bit, and found a fairly interesting failure
> mode. If I boot init=/bin/bash vga=1, I get ~2 wakeups a second, nice.
> 
> When I boot init=/bin/bash vga=791 (vesa framebuffer), most wakeups
> are caused by cursor painting (I should fix that some day, I
> guess). But... the cursor blinking does not even work properly!
> 
> It blinks at normal speed, then (randomly) it blinks slowly, then gets
> back to normal speed, then inserts longer delay.
> 
> The effect is so nice that I thought about youtube ;-). Thinkpad
> x60.. question is, how to debug it? 

The cursor blinking is done by software via a timer. It's in
drivers/video/console/fbcon.c.

With the latest -rc kernel you can turn off the blinking with

echo 0 > /sys/class/graphics/fbcon/cursor_blink

Tony


