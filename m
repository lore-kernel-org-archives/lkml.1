Return-Path: <linux-kernel-owner+w=401wt.eu-S933437AbZGPV10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbZGPV10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 17:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbZGPV1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 17:27:25 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50169 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381AbZGPV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 17:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LzgNZVXs9Rlite1Dnd2VskaYpdI94ajOTmGou5C8yWqQpDHJ3udMt/YvlDBrZYwNCZ
         Y+9vTZ7fI+Y+aHynha/qWX8OHAg86LOI5T7SBmzNIPHghlXq8A9Em8AWFNyJWd/34U4Y
         TKrWOBvOwZr7KrGbQQ3Qq1g70orHLnS/awABE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] add "VmUsers: N" to /proc/$PID/status
Date: Thu, 16 Jul 2009 23:27:25 +0200
User-Agent: KMail/1.8.2
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200907150322.18123.vda.linux@googlemail.com> <48286.1247773600@turing-police.cc.vt.edu>
In-Reply-To: <48286.1247773600@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907162327.25700.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009 21:46, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 15 Jul 2009 03:22:18 +0200, Denys Vlasenko said:
> 
> > It can be nice to know how many such CLONE_VM'ed processes
> > share VM with given /proc/PID. Then it would be possible to do
> > more accurate accounting of memory usage. Say, by dividing
> > all memory usage numbers of this process by this number.
> 
> Process A clones a process A1.  Process B clones a process B1. Now
> all 4 of them have 'VmUsers: 2' on them, but there's no clean way to tell
> whether A1 or B1 is the one sharing with A, or with B.
> 
> The patch is probably sufficient if all you want is some N to divide by, but
> not if you care *which* processes are sharing how much.

You are right. There is more: the truly accurate accounting
needs to be per page. Like /proc/$PID/smaps
and /proc/$PID/pagemap. (However, I am not sure you can
relize that two processes share a VM by looking
at these files either)

I do not aim to solve _that_ problem with my patch.

I, indeed, want to have just an N I can divide RSS/VSZ/etc by,
to get, say, top display which do not mislead user
into thinking that he has 3 processes with 100 megabyte RSS
when in reality he has 3 processes sharing a single VM
with 100 meg RSS.

This will still not be completely accurate due to per-page
sharing and such, but it will be more accurate
than what we have now.
--
vda
