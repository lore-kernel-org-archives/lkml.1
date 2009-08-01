Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZHAQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZHAQKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZHAQKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 12:10:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36787 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbZHAQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 12:10:45 -0400
Date: Sat, 1 Aug 2009 17:11:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 2.6.31-rc4] gigaset: really fix chars_in_buffer
Message-ID: <20090801171141.7a463347@lxorguk.ukuu.org.uk>
In-Reply-To: <20090801-patch-01.tilman@imap.cc>
References: <20090801-patch-01.tilman@imap.cc>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  1 Aug 2009 14:18:51 +0200 (CEST)
Tilman Schmidt <tilman@imap.cc> wrote:

> This patch corrects the problem noted but left unfixed by commit
> 23198fda7182969b619613a555f8645fdc3dc334 "tty: fix chars_in_buffers".
> The tty_operation chars_in_buffer() should return zero, not a
> negative value, in the error case.

Is that correct. If you take a signal so the mutex_lock_interruptible
takes the error path we'll exit any waits for characters to be flushed
from buffers and lose the bytes in some cases ? Thats why I didn't
convert it - I didn't understand why it was using _interruptible at all ?

Alan
