Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZKRSPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZKRSPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZKRSPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:15:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43569 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758064AbZKRSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:15:48 -0500
Date: Wed, 18 Nov 2009 18:17:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118181712.14a2404c@lxorguk.ukuu.org.uk>
In-Reply-To: <20091118175307.GQ21750@bolzano.suse.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
	<20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
	<20091118175307.GQ21750@bolzano.suse.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As I said, f_pos is changed without holding BKL in the VFS already. Therefore

IFF the VFS paths that change it can be invoked in parallel.

> even if the driver tries to protect f_pos by holding the BKL it is racing
> against concurrent read()/write() anyway on f_pos.

It may simply be a matter of internal consistency. Anyway I've now made a
list of the offenders so we can simply fix/delete them and continue.
