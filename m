Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZJUNQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZJUNQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZJUNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:16:23 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44981 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZJUNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 09:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=VjkzGqDcYs9rJbsTfX6Eop3DPjw37zDaysvQ4b5YROEc66CMAWxayUkOomeTxIIDbs
         M4j8PG9RXA1wVO1mUFepWJI4UuhIpdYiWfTby4WgiBTGgqugFfQWYpSq0J+alkNbq4Ji
         9SSQqmIazqdy16S/9NdqvEdfrMP/nSE55FpF0=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Date: Wed, 21 Oct 2009 15:16:20 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mattia Dongili <malattia@linux.it>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <200910211029.21702.arnd@arndb.de> <alpine.LFD.2.00.0910211226180.3526@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910211226180.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910211516.20614.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 October 2009, John Kacur wrote:
> From 96872f13a510db69fbb32f9e956615cd826f8986 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sun, 18 Oct 2009 23:49:49 +0200
> Subject: [PATCH] sony_pi: Remove the BKL from open and ioctl
> 
> The BKL is in this function because of the BKL pushdown
> (see commit f8f2c79d594463427f7114cedb1555110d547d89)
> 
> It is not needed here because the mutex_lock sonypi_device.lock
> provides the necessary locking.
> 
> sonpi_misc_ioctl can be converted to unlocked ioctls since it relies on
> its own locking (the mutex sonypi_device.lock) and not the bkl
> 
> Document that llseek is not needed by explictly setting it to no_llseek
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

This looks perfect to me now. Just a few hundred more of these,
and we're done with the drivers ;-)
