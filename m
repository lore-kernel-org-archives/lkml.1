Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXLRSbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXLRSbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXLRSav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:30:51 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38207 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXLRSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:30:50 -0500
Date: Tue, 18 Dec 2007 19:30:49 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Nichols <jamesnichols3@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
In-Reply-To: <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712181923420.4422@fbirervta.pbzchgretzou.qr>
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com> 
 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr> 
 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com> 
 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr> 
 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com> 
 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr> 
 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com> 
 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 18 2007 13:21, James Nichols wrote:
>
>> Well you could still blame Java. I am sure that if you program was C,
>> the problem could be narrowed down much easier.
>
>I'm curious to know how this problem would be easier to narrow down if
>it were written in C.
>
It depends on the developers preference after all. libc is
'well-known' and who knows what bugs hide in the jre (it was not so
open until recently). I have seen obscure things in aurora linux's
glibc whereby concurrent use of malloc() in threaded applications
will hang because some malloc_mutex was probably trashed. Which tells
me that the lesser code there is, the better.

In your specific case it is likely to be not in userspace if the
socket remains in SYN_SENT, but I was speaking in general terms
(lesser is better). Usually, one would take out tcpdump, look for
SYN ACK packets arriving. If they don't arrive, check router. If they
appear, check the TCP input code path in the kernel. So much about
how to proceed :)
