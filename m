Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZKUQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZKUQ4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZKUQ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:56:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZKUQ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:56:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 01/15] Introduce noop_llseek()
Date: Sat, 21 Nov 2009 17:56:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Matthew Wilcox <matthew@wil.cx>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de> <20091120170547.GF20634@shareable.org> <20091120171107.GZ21750@bolzano.suse.de>
In-Reply-To: <20091120171107.GZ21750@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911211756.27596.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18R6QcGGFPthhKKxuFAwjCLk3In/8IQsnXVj57
 xhKGUx/8emoRD7CW/kg33IBGd3/7Bv7F/rqpKGE3XeGpt3YHwB
 7uhJOCsRfb2R9wt5bvSqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 November 2009, Jan Blunck wrote:
> On Fri, Nov 20, Jamie Lokier wrote:
> 
> > Jan Blunck wrote:
> > > The noop_llseek() is a llseek() operation that filesystems can use that
> > > don't want to support seeking (leave the file->f_pos untouched) but still
> > > want to let the syscall itself to succeed.
> > 
> > This is weird behaviour: if you want to allow llseek() to succeed but
> > don't really support seeking, why does the device even care about the
> > value of file->f_pos?
> 
> The device itself does not care about it but it is userspace that is expecting
> the seek to succeed. There is a comment in osst that at least there seems to
> be a borken version of tar that wants to seek on the device even it that does
> not have any effect.

Looking at the question from the other side -- if the device and the user
don't care about file->f_pos, what's wrong with calling generic_file_llseek
instead of noop_llseek?

	Arnd <><
