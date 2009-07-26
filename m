Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZGZPqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZGZPqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 11:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZGZPqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 11:46:51 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:43937 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZGZPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 11:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XhmSirEtxyPVDvJ6l8Gm98kW+auBFe2/HPCyGZiW7TqAe4MCPFLiKnm9MBjcU1iX6L
         rv5IBRE9RHPCCJGr0W0OJ7ZoezCrG5aHKZKLSKQOcddCCimqWLbxBU5LTeMPfOGgitsn
         PZD3b0uozUx54b6Dc/b26hvVLx7cvKxVmrvpc=
MIME-Version: 1.0
In-Reply-To: <1246536889.22562.74.camel@dhcp235-23.rdu.redhat.com>
References: <1246510598-6136-1-git-send-email-keithp@keithp.com>
	 <1246536889.22562.74.camel@dhcp235-23.rdu.redhat.com>
Date: Sun, 26 Jul 2009 17:46:49 +0200
Message-ID: <81b0412b0907260846i1cce0e81m6c7bf99263fb4c1@mail.gmail.com>
Subject: Re: [PATCH] fs/notify/inotify: decrement user inotify count on close
From: Alex Riesen <raa.lkml@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 14:14, Eric Paris<eparis@redhat.com> wrote:
> On Wed, 2009-07-01 at 21:56 -0700, Keith Packard wrote:
>> The per-user inotify_devs value is incremented each time a new file is
>> allocated, but never decremented. This led to inotify_init failing after a
>> limited number of calls.
>>
>> Signed-off-by: Keith Packard <keithp@keithp.com>
>
> Thanks, I will push to Linus later today, sorry about the regression!
>

Hmm... Either the patch wasn't enough, or it was broken again.
On v2.6.31-rc4, I get this:

  # echo 10 >/proc/sys/fs/inotify/max_user_watches
  # inotifywatch -r /usr/lib # generate watches up to the limit
  Establishing watches...
  Failed to watch /bin; upper limit on inotify watches reached!
  Please increase the amount of inotify watches allowed per user via
`/proc/sys/fs/inotify/max_user_watches'.
  # inotifywatch /bin/true # just one watch for just one file

AFAIU, the second inotifywatch should work, and the watches of the first,
failed, run must be cleared.
