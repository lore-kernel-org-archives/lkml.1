Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbZJKTcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbZJKTcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZJKTcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:32:21 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59535 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZJKTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=bC56aZlRcit8jr7DrIprGuxBdmmIRz5mJfJKsoTw34NTdNL74zqv5GfuV/VZlUNVX0
         GvDx83tVkaeXoi9A656I/tBfCkXogwXrAhMunFBGssHDl3Urk96qIR/TMGqRUHoRA57r
         DO6cD5z9q3OHjJtCJPzpKhZXHdF+1FyGm5g70=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
Date: Sun, 11 Oct 2009 21:31:40 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "Sven-Thorsten Dietrich" <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
References: <20091010153314.827301943@linutronix.de> <20091010153349.499835683@linutronix.de>
In-Reply-To: <20091010153349.499835683@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910112131.40608.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, Thomas Gleixner wrote:
> There is nothing to protect inside nvram_llseek(), the file
> offset doesn't need to be protected and nvram_len is only
> initialized from an __init path.
> 
> It's safe to remove the big kernel lock there.
> 

The generic_nvram driver still uses ->ioctl instead of ->unlocked_ioctl.
I guess it would be helpful to change that in the same series, so we
don't get the BKL back as soon as someone does a pushdown into the
remaining ioctl functions.

	Arnd <><
