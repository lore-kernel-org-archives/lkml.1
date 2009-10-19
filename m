Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbZJSWA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbZJSWA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbZJSWA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:00:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50604 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbZJSWA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=r+YeAd7JhRRA9zJyhV+OvTuODxI4KQLFCnW0OlLzEhSb8jUH+iBN02Q1MlKOADjJJb
         eNX/MZ+1NZmZ+w3uH3/oJKv2fSyyIgp3ot9Ddx5rplyE9iBwsPC39aZRKW3mwBEyvi6d
         BrWNJIgpmCIBxPUnpQpBQEFLU9ZlHBJe+Xrmk=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Date: Tue, 20 Oct 2009 00:00:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <200910190619.48037.arnd@arndb.de> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910200000.24574.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 October 2009, John Kacur wrote:
> How does this look? (Version 2 of the patch follows)

Looks good now.

> From efd07cfcd021b4438d83d383ab81f9b35cb41eb9 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sun, 18 Oct 2009 23:49:49 +0200
> Subject: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
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
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
