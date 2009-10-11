Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbZJKTYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbZJKTYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZJKTYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:24:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49901 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZJKTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vj3nzxBBZSGdjjmtI1bIMlBpNms3LKHO1vdvYTIdyoJUrn6nfS0SAxy6HNSaKXVaNQ
         vkdWBDSiDcd0nj7uwMEm4WPdWU44/SBt9HT5pimTKJthUZbL1N9BKXAFaJBPB7qwMP+z
         tHU4a8GRGe2SKh4llr3SCtpfk546E4PJrClZQ=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/28] drivers: Remove BKL from drivers/char/misc.c
Date: Sun, 11 Oct 2009 21:24:00 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20091010153314.827301943@linutronix.de> <20091010153349.237173041@linutronix.de>
In-Reply-To: <20091010153349.237173041@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910112124.00747.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, Thomas Gleixner wrote:
> misc_open() is already serialized with misc_mtx. Remove the BKL
> locking which got there via the BKL pushdown.

This only works as long as all misc drivers also don't need the BKL
in /their/ open methods. I believe that we did a pushdown into them
last year, but new ones may have crept up.

I guess we really should have kill this one off back then, but somehow
it was forgotten about.

	Arnd <><
