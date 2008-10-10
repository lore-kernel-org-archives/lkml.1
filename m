Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYJJJl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYJJJl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYJJJlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:41:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33532 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYJJJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:41:50 -0400
Subject: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: zanussi@comcast.net, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1223629803.8959.40.camel@penberg-laptop>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
Date: Fri, 10 Oct 2008 12:42:03 +0300
Message-Id: <1223631723.8959.46.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm cc'ing Tom, Jens, and LKML.)

On Fri, 2008-10-10 at 12:10 +0300, Pekka Enberg wrote:
> > I'm seeing a hard lock on my machine when I run kmemtraced with the
> > following patch applied:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=17ca1d5506b1db433f0b7167a627bfd55d319dd3
> > 
> > I can enable/disable kmemtrace via the debugfs files fine and can also
> > read the relay files with cat.
> > 
> > Any idea where this is coming from?
> 
> OK, it's the first splice() call in reader_thread() that causes the
> hang. Hmm.

To recap, with a CONFIG_KMEMTRACE enabled kernel from the
"topic/kmemtrace" branch of:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git topic/kmemtrace

running the "kmemtraced" program from

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/kmemtrace-user.git

results to a hard lock on my machine. I am unable to find anything
obviously wrong with it and as I can read/write the relay files just
fine, I'm beginning to think it's problem in relayfs splice
implementation.

Tom, thoughts?

		Pekka


