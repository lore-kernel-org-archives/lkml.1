Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbYJ0PTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbYJ0PTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJ0PTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:19:30 -0400
Received: from khc.piap.pl ([195.187.100.11]:33383 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYJ0PT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:19:29 -0400
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] kill suid bit only for regular files
References: <1224424839-3892-1-git-send-email-dmonakhov@openvz.org>
	<20081026214741.332c7656.akpm@linux-foundation.org>
	<m363nebi2n.fsf@dmon-lap.sw.ru>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 27 Oct 2008 16:19:26 +0100
In-Reply-To: <m363nebi2n.fsf@dmon-lap.sw.ru> (Dmitri Monakhov's message of "Mon\, 27 Oct 2008 10\:41\:52 +0300")
Message-ID: <m3y70a3w1t.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Monakhov <dmonakhov@openvz.org> writes:

>> Are we sure that should_remove_suid() is not and never will used for
>> directories?
> This bits are meaningless for directory. Posix is quiet about this case.

> Ok. Will do. My point is: it is improbable what some body(except me :) )
> want to set S_ISUID/S_ISGID bit for non regular files. But it is 
> technically possible and result in unexpected consequence.

I don't know about the context, but SGID bits for directories are not
magic, they mean the newly created files will inherit GID from the
parent directory, and if the file is actually a subdirectory, it will
also have SGID set. The same was also true WRT SUID bits on some
systems.
-- 
Krzysztof Halasa
