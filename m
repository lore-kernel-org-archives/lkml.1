Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247AbZJKTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbZJKTsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZJKTsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:48:39 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:40338 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZJKTsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=nTDjTAak495EvQTKg4rnLP+yok0HdTOncKQ81Ld0tVuvvE9rtlTZjK247XX5rySX0l
         DT0KRwHkrBSN8CEH6+wcsAeNSXtvCQxlV/BT2DLHUt6tx8M1gUcLFaFG/+tB7395NhFB
         y9bLEMsHcIEva1p9DjNHWx9Y06NTUkjAtg15E=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/28] input: Remove BKL from hp_sdc_rtc
Date: Sun, 11 Oct 2009 21:47:55 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Dmitry Torokhov <dtor@mail.ru>
References: <20091010153314.827301943@linutronix.de> <20091010153349.884891604@linutronix.de>
In-Reply-To: <20091010153349.884891604@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910112147.55546.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, Thomas Gleixner wrote:
> cycle_kernel_lock() was added during the big BKL pushdown. It should
> ensure the serializiation against driver init code. In this case there
> is nothing to serialize. Remove it.

The driver still holds the BKL in its ioctl method, which should be removed
as well if the above is true.

	Arnd <><
