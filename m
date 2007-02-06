Return-Path: <linux-kernel-owner+w=401wt.eu-S965221AbXBFAQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221AbXBFAQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965244AbXBFAQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:16:31 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37893 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbXBFAQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:16:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH[RFC] kill sysrq-u (emergency remount r/o)
References: <20070205173247.GA25790@lst.de>
Date: Mon, 05 Feb 2007 17:15:14 -0700
In-Reply-To: <20070205173247.GA25790@lst.de> (Christoph Hellwig's message of
	"Mon, 5 Feb 2007 18:32:47 +0100")
Message-ID: <m17iuww38t.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Hi there,
>
> in two recent discussions (file_list_lock scalability and remount r/o
> on suspend) I stumbled over this emergency remount feature.  It's not
> actually useful because it tries a potentially dangerous remount
> despite writers still beeing in progress, which we can't get rid.
>
> I've attached one patch in this mail that simply kills the
> functionality, and in a reply to this mail I'll send a second one
> that keeps the sysrq functionality, but removes the force argument
> from do_remount_sb that overrides the still busy check.  This version
> is currently not useful, but makes a lot of sense once Dave Hansens
> per-mountpoint r/o patches get in, as we can check for a real write
> in progress instead of simply a file opened with write permission.
>
> Any ideas and comments?

Most things that sysrq allows you to do are dubious but work most
of the time, and are much better than the alternatives.  Synching and
remounting read-only are several of those, so is rebooting.  If you
look at the emergency reboot path it doesn't do the clean shutdown
that every other reboot path does.

So if it is a maintenance problem I'm inclined to believe there is
a problem that needs fixing.  Otherwise I'm not certain you understand
the point of making thees things available with sysrq.

Eric
