Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0BBNmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:42:09 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:7938 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0BBNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hP2zMA4WjV7JeN6Wk97o4tceEAHJ0p6CTOSQiAvHStxn/Fo/JUVHMwS/uaFylF0c5j
         4rAOqXVjh00V37J5AAYqbLNVT2Eq5Fl0kVZF9611WuQ7/pU6KrwVrfWZgwKycfG29Eyp
         Hw+U2D2Q4Pke5488MJeGUfBsF1nhzfoaj0J/4=
MIME-Version: 1.0
In-Reply-To: <1265114375.12634.61.camel@pc1117.cambridge.arm.com>
References: <20100129185434.GH19501@one-eyed-alien.net>
	 <201002021248.10994.oliver@neukum.org>
	 <1265112072.12634.53.camel@pc1117.cambridge.arm.com>
	 <201002021307.56991.oliver@neukum.org>
	 <1265114375.12634.61.camel@pc1117.cambridge.arm.com>
Date: Tue, 2 Feb 2010 21:36:05 +0800
Message-ID: <d82e647a1002020536q778a9339na9abb57c3d71ccf4@mail.gmail.com>
Subject: Re: USB mass storage and ARM cache coherency
From: Ming Lei <tom.leiming@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/2 Catalin Marinas <catalin.marinas@arm.com>:

> In the iSCSI case, does the HCD driver write directly to a page cache
> page? Or it just fills in network packets that are copied to page cache
> pages by the iSCSI code (sorry, I'm not familiar with this part of the
> kernel). If the latter, the cache flushing in the HCD driver would not
> help and it needs to be done in the iSCSI code.

So we should flush dcache page in the place where the user mapped
page is copied to, instead of low level driver which does not do such
thing always.

-- 
Lei Ming
