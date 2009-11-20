Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZKTRLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZKTRLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZKTRLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:11:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbZKTRLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:11:01 -0500
Date: Fri, 20 Nov 2009 18:11:07 +0100
From: Jan Blunck <jblunck@suse.de>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 01/15] Introduce noop_llseek()
Message-ID: <20091120171107.GZ21750@bolzano.suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de> <1258735245-25826-2-git-send-email-jblunck@suse.de> <20091120170547.GF20634@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120170547.GF20634@shareable.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, Jamie Lokier wrote:

> Jan Blunck wrote:
> > The noop_llseek() is a llseek() operation that filesystems can use that
> > don't want to support seeking (leave the file->f_pos untouched) but still
> > want to let the syscall itself to succeed.
> 
> This is weird behaviour: if you want to allow llseek() to succeed but
> don't really support seeking, why does the device even care about the
> value of file->f_pos?

The device itself does not care about it but it is userspace that is expecting
the seek to succeed. There is a comment in osst that at least there seems to
be a borken version of tar that wants to seek on the device even it that does
not have any effect.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
