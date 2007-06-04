Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbXFDUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbXFDUBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbXFDUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:01:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:52240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903AbXFDUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:01:04 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Syslets, signals, and security
References: <20070604163145.GA7144@c2.user-mode-linux.org>
	<20070604174542.GD29201@mami.zabbo.net>
	<20070604191349.GA8903@c2.user-mode-linux.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Jun 2007 22:57:34 +0200
In-Reply-To: <20070604191349.GA8903@c2.user-mode-linux.org>
Message-ID: <p73vee3a14x.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike <jdike@addtoit.com> writes:

> How about splitting the credentials out of the task_struct and making
> them sharable ala ->mm et al?  You change uid there and it changes for
> everyone.  It will make fork slightly more expensive though.

Strictly that's required by POSIX anyways. But it's a real mess.

The problem is that you would need to reference count/lock them in every
syscall or ioctl or similar. Otherwise another thread
could change them in the middle of a syscall which wouldn't be
good. Doing this full reference counting would be probably somewhat
expensive with more locked cycles and also a lot of work to implement.
You would need to audit large parts of the source tree.

I don't think it's a good idea.

-Andi
