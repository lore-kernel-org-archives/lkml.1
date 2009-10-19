Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbZJSETv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbZJSETv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 00:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZJSETv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 00:19:51 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42590 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZJSETu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 00:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=luM8xF8DaE/+19WLDeLBKuO4SwfS51m5eBJGw8lUvVUvJ/9tIpd+28a4h5v10lFaFu
         D6ukeWPR2/QVZx/xrqqVY/p1Hn/ag1hIKK5YeTfAPIcaPCv55THkaq1giRhwEFpOe1UT
         iG60UlvoV5TRYbPTKZy3pYjQgZDWPrzlt1cyk=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Date: Mon, 19 Oct 2009 06:19:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910190619.48037.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 October 2009, John Kacur wrote:
> The BKL is in this function because of the BKL pushdown
> (see commit f8f2c79d594463427f7114cedb1555110d547d89)
> 
> It is not needed here because the mutex_lock sonypi_device.lock
> provides the necessary locking.

The driver still uses the BKL in the ioctl function, which can
probably be removed at the same time.

	Arnd <><
