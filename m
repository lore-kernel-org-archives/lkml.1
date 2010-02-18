Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab0BRCrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:47:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44174 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab0BRCrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:47:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d2B+3Hbs1qJzM3bzmAUFa35Luwj8a93nvjZu8kGXn3Q6S6C9aMiCS58qpWk/Aisv3D
         wTsMnJIm8lGUWg1MmjEF4lvSVfNELtH57zVnixlyILi9CWnR1fcuxlkVbFXCdc+0Y35p
         m+sqCYWx5puANl3AEgSzPGNALu0zjOx1bc3rI=
MIME-Version: 1.0
In-Reply-To: <3e8340491002171819h4d63d592ube70f327eb92d798@mail.gmail.com>
References: <23986fd91002161153y516bb5e3i9e85f11469b9160e@mail.gmail.com>
	 <3e8340491002171819h4d63d592ube70f327eb92d798@mail.gmail.com>
Date: Wed, 17 Feb 2010 18:47:07 -0800
Message-ID: <23986fd91002171847l749e71eh6a71259b1ff0a2df@mail.gmail.com>
Subject: Re: sendfile() expert advice sought
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 6:19 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>
> sendfile() always copies pages

Really?  So the description in the following article (see "Figure 4") is wrong?

http://www.linuxjournal.com/article/6345?page=0,1

(To be clear, I want to replace the step where the kernel buffers get
populated from disk with a step where I populate them programatically.
 That is what I mean by "sendfile() for anonymous pages".)

According to that article, among others, if your network device
supports scatter/gather and the pages are already resident, then
sendfile() is a true zero-copy operation.  That is, it takes page
cache pages and arranges to DMA them to the network card without
creating any additional copies in system RAM.

My questions make a lot more sense if that is how it works, anyway :-).

 - Pat
