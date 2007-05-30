Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXE3TlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXE3TlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXE3TlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:41:04 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1360 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXE3TlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:41:03 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 12:40:59 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <20070530084252.GA15708@elte.hu>
Message-ID: <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Ingo Molnar wrote:

> yeah - this is a fundamental design question for Linus i guess :-) glibc 
> (and other infrastructure libraries) have a fundamental problem: they 
> cannot (and do not) presently use persistent file descriptors to make 
> use of kernel functionality, due to ABI side-effects. [applications can 
> dup into an fd used by glibc, applications can close it - shells close 
> fds blindly for example, etc.] Today glibc simply cannot open a file 
> descriptor and keep it open while application code is running due to 
> these problems.

Here I think we are forgetting that glibc is userspace and there's no 
separation between the application code and glibc code. An application 
linking to glibc can break glibc in thousand ways, indipendently from fds 
or not fds. Like complaining that glibc is broken because printf() 
suddendly does not work anymore ;)

#include <stdio.h>
int main(void) {
        close(fileno(stdout));
        printf("Whiskey Tango Foxtrot?\n");
        return 0;
}



- Davide


