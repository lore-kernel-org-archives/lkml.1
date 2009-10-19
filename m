Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZJSWI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZJSWI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZJSWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:08:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:56544 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbZJSWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ijtYCI9Du7c9L/tHjb/FWaQ1RkW3ENVDeChsW1Yp/Vc0h9jVhlX8MMZ2ibD0aDwl01
         cDct4SUBl3kIQnF/T/65Edvdz2KGgEQpHaTxR0xRzPBrWB11wr01/eNOe4bAtJbYA0/V
         HzSH/pY/zxaERrgGEUJfIxEj8Ji2SfGqBSRw8=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Date: Tue, 20 Oct 2009 00:08:57 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de>
In-Reply-To: <200910200000.24574.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910200008.57468.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 October 2009, Arnd Bergmann wrote:
> On Monday 19 October 2009, John Kacur wrote:
> > How does this look? (Version 2 of the patch follows)
> 
> Looks good now.
> 

A bit of background:

Doing only one of the two conversions is a correct patch as well
of course, I just want to make sure you don't have to go through all
the same files again once someone does a blind pushdown into the ioctl
and llseek functions, so once you prove that a specific driver doesn't
need the BKL, please always make sure to remove it from all three places.

I fear that the llseek part will get interesting as well, just because
we call default_llseek instead of no_ll by default currently.
It might be a good idea to add one of .llseek=no_llseek or 
.llseek=generic_file_llseek in any file_operations that you prove
to not require the BKL.

	Arnd <><
