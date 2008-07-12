Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYGLU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYGLU5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYGLU5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:57:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:36060 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYGLU5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fxw4izEkoQUsyB0W6ANTbFDGFQ+CP0siD8xNO/bp2pt6RF6ZYKikVz9qjYUmKukKN6
         6df4ljLJvqn5rA3Yd7l3Z2kVCZzhSZdxU5IlJ4d9dSHE63CcXxAyD1LFly9C4hqxHUO6
         w5UiRg80IB/Shmp065cXvuvm9FogBsc3oLSfo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Subject: Re: [PATCH] x86_64: fix delayed signals
Date: Sat, 12 Jul 2008 22:57:59 +0200
User-Agent: KMail/1.8.2
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807121011470.2875@woody.linux-foundation.org> <48791393.1020107@gmail.com>
In-Reply-To: <48791393.1020107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807122257.59047.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 July 2008 22:26, Török Edwin wrote:
> A bit off-topic, but something I noticed during the tests:
> In my original test I have rm-ed the files right after launching dd in
> the background, yet it still continued to write to the disk.
> I can understand that if the file is opened O_RDWR, you might seek back
> and read what you wrote, so Linux needs to actually do the write,
> but why does it insist on writing to the disk, on a file opened with
> O_WRONLY, after the file itself got unlinked?

Because process can do 

fcntl(fd, F_SETFL, fcntl(fd, F_GETFL) | O_RDWR)

at any time.
--
vda
