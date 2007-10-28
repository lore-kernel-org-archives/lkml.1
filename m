Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbXJ1STb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbXJ1STb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbXJ1STY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:19:24 -0400
Received: from science.horizon.com ([192.35.100.1]:15316 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751312AbXJ1STX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:19:23 -0400
Date: 28 Oct 2007 14:19:18 -0400
Message-ID: <20071028181918.28014.qmail@science.horizon.com>
From: linux@horizon.com
To: bart.vanassche@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is gcc thread-unsafe?
Cc: aph@redhat.com, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a note on the attribute((acquire,release)) proposal:

It's nice to be able to annotate functions, but please don't forget to
provide a way to write such functions.  Ultimately, there will be an
asm() or assignment that is the acquire or release point, and GCC needs
to know that so it can compile the function itself (possibly inline).

Having just a function attribute leaves the problem that

void __attribute__((noreturn))
_exit(int status)
{
	asm("int 0x80" : : (__NR_exit) "a", (status) "b" );
}

generates a complaint about a noreturn function returning, because
there's no way to tell GCC about a non-returning statement.
