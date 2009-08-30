Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZH3TFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZH3TFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZH3TFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:05:38 -0400
Received: from www84.your-server.de ([213.133.104.84]:45581 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZH3TFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:05:37 -0400
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090829231650.GA29419@infradead.org>
References: <1251563892.13287.11.camel@wall-e>
	 <20090829231650.GA29419@infradead.org>
Content-Type: text/plain
Date: Sun, 30 Aug 2009 21:05:44 +0200
Message-Id: <1251659144.20987.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 29.08.2009, 19:16 -0400 schrieb Christoph Hellwig:
> On Sat, Aug 29, 2009 at 06:38:12PM +0200, Stefani Seibold wrote:
> > The following fix a long standing issue in the proc_file_write function,
> > which doesn't update the ppos file position pointer.
> 
> The right fix is to get rid of the last remaining
> read_proc_t/write_proc_t instances and switch everyone to implement file
> operations.  Alexey has been working on this on and off for a while.
> 

Switching all users of read_proc_t/write_proc_t to file operation is a
huge job. About 180 files must be fixed.

But the main reason not to do this is because the breakage of "out of
tree" drivers.

I like the current simplified proc interface. It saves a lot of code
duplication because the basic operations will be handled inside the
kernel and not in the driver.

There is no reason for Alexey to finish his work, submit it and maybe it
will be accepted. 

In the meantime i will see my patch as the preferred solution: a cleanup
of the current interface.


