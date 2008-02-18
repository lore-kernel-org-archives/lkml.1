Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYBRODz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYBRODz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYBRODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:03:47 -0500
Received: from ns.suse.de ([195.135.220.2]:50127 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYBRODp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:03:45 -0500
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
From: Andi Kleen <andi@firstfloor.org>
References: <47B980AC.2080806@wpkg.org>
Date: Mon, 18 Feb 2008 15:03:44 +0100
In-Reply-To: <47B980AC.2080806@wpkg.org> (Tomasz Chmielewski's message of "Mon\, 18 Feb 2008 13\:57\:16 +0100")
Message-ID: <p7363wmxsxr.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski <mangoo@wpkg.org> writes:
>
> Is it normal to expect the write speed go down to only few dozens of
> kilobytes/s? Is it because of that many seeks? Can it be somehow
> optimized? 

I have similar problems on my linux source partition which also
has a lot of hard linked files (although probably not quite
as many as you do). It seems like hard linking prevents
some of the heuristics ext* uses to generate non fragmented
disk layouts and the resulting seeking makes things slow.

What has helped a bit was to recreate the file system with -O^dir_index
dir_index seems to cause more seeks.

Also keeping enough free space is also a good idea because that
allows the file system code better choices on where to place data.

-Andi

