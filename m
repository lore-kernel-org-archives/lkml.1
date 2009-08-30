Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbZH3TKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbZH3TKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZH3TKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:10:35 -0400
Received: from www84.your-server.de ([213.133.104.84]:57533 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZH3TKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:10:34 -0400
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090830080937.GA13999@x200.localdomain>
References: <1251563892.13287.11.camel@wall-e>
	 <20090829231650.GA29419@infradead.org>
	 <20090830080937.GA13999@x200.localdomain>
Content-Type: text/plain
Date: Sun, 30 Aug 2009 21:10:43 +0200
Message-Id: <1251659443.20987.23.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 30.08.2009, 12:09 +0400 schrieb Alexey Dobriyan:
> On Sat, Aug 29, 2009 at 07:16:50PM -0400, Christoph Hellwig wrote:
> > On Sat, Aug 29, 2009 at 06:38:12PM +0200, Stefani Seibold wrote:
> > > The following fix a long standing issue in the proc_file_write function,
> > > which doesn't update the ppos file position pointer.
> > 
> > The right fix is to get rid of the last remaining
> > read_proc_t/write_proc_t instances and switch everyone to implement file
> > operations.  Alexey has been working on this on and off for a while.
> 
> Yes, please, ->write_proc is going to end very soon.
> 
> As for prevoius arguments:
> - changing ->write_proc signature is _of course_ going to break
>   out-of-tree stuff

No, it breaks nothing. You get only a warning. I think thats okay...

> - ->proc_fops worked since forever, and since it's struct file_operations,
>   nobody prohibits implementing ->write with pos update and what not.
> - seq_file is not relevant to this issue because seq_file is for read path
>   only.
> 
> Back into SCSI pile of users.


