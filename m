Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZDDXcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZDDXcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 19:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZDDXcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 19:32:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:56983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZDDXcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 19:32:20 -0400
Date: Sat, 4 Apr 2009 16:33:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Message-ID: <20090404163349.20df1208@infradead.org>
In-Reply-To: <20090404232222.GA7480@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
	<alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
	<alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
	<20090404135719.GA9812@mit.edu>
	<20090404151649.GE5178@kernel.dk>
	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
	<20090404173412.GF5178@kernel.dk>
	<alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
	<20090404180108.GH5178@kernel.dk>
	<20090404232222.GA7480@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Apr 2009 19:22:22 -0400
Theodore Tso <tytso@mit.edu> wrote:
> 
> However, the full latency fixes all the writes are synchronous, so it
> must be the case that the delays are caused by the fact that queue is
> getting implicitly unplugged after the synchronous write, and the
> problem is no longer the mixing of WRITE and WRITE_SYNC requests as
> posted in the commit log for 78f707bf.  If we remove the automatic
> unplug for WRITE_SYNC requests, and add an explicit unplug where it is
> needed, that should fix the performance regression for this particular
> sqlite test case. 

removing the unplug is bound to be bad; after all we're waiting on the
IO. But maybe it should be "make the unplug a REALLY short time".
At least for rotating storage. For non-rotating .. I'd never wait.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
