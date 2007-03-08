Return-Path: <linux-kernel-owner+w=401wt.eu-S1161311AbXCHX5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161311AbXCHX5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161282AbXCHX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:57:43 -0500
Received: from gw.goop.org ([64.81.55.164]:58551 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161268AbXCHX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:57:42 -0500
Message-ID: <45F0A2F2.3080102@goop.org>
Date: Thu, 08 Mar 2007 15:57:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com> <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So I think you should get rid of signalfd_dequeue(), and just replace it 
> with a "read()" function.
>   

The difficulty is that there are 4 different formats of signal structure
you could get: (traditional|siginfo) x (32bit|64bit).

What happens if you're a 32 bit process, you fork and exec a 64bit
process who inherits the signalfd, and they start reading?  What format
of signal structure do they get?  What do you get?  What if you start
doing partial reads?

I think signalfd_dequeue() is warty, but read() has has a number of
details to sort out.

(Hey, can you send signals by writing into the signalfd?  Very plan9...)

    J
