Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYBJXND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYBJXND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYBJXMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:12:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43382 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752105AbYBJXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:12:53 -0500
Date: Sun, 10 Feb 2008 23:05:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org, "Jorge Boncompte" <jorge@dti2.net>,
       "Jean Delvare" <khali@linux-fr.org>, "Chris Gauthron" <chrisg@0-in.com>
Subject: Re: I/O collisions w/ hwmon/it87.c and watchdog/it8712f_wdt.c?
 (Super I/O chips in general..)
Message-ID: <20080210230538.3f5743f6@core>
In-Reply-To: <76366b180802101304j359e2873vd9dd974920bf6745@mail.gmail.com>
References: <76366b180802101304j359e2873vd9dd974920bf6745@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since these chips touch many different parts of traditionally separate
> driver areas, how should the drivers be structured so that they can
> all talk to the chip? Should the low level communications routines for
> the chip live in a library which all the drivers could use? 

Probably yes. And that if possible should manage all the locking. Thats
roughly how the majority of drivers do it. Some export the lock from base
code and inline the accessors depending how complex it is.
