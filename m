Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbXJ3Rbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbXJ3Rbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXJ3Rbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:31:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXJ3Rbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:31:31 -0400
Date: Tue, 30 Oct 2007 13:31:25 -0400
From: Rik van Riel <riel@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
Message-ID: <20071030133125.3458420c@cuia.boston.redhat.com>
In-Reply-To: <20071030155525.GF9702@duck.suse.cz>
References: <20071018201531.GA5938@dmt>
	<20071030145720.GB27039@atrey.karlin.mff.cuni.cz>
	<20071030112346.4b48bfe5@cuia.boston.redhat.com>
	<20071030155525.GF9702@duck.suse.cz>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 16:55:25 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hmm, that's right, but still the kernel->userspace interface could be via
> netlink (which is much more flexible than signals etc.) and then in userspace
> we could implement also some simple interface (UNIX socket?) for server like
> apps...

I think we all agree that it should not be a Unix signal, if only
because glibc cannot manipulate memory pools from signal handlers :)

The low memory message (for lack of a better word) needs to get to
userspace over a file descriptor, which the process can select() or
poll() on from its main loop.

Whether that is a device node, a sysfs file, a netlink socket or
something else ... I don't particularly care :)

-- 
All Rights Reversed
