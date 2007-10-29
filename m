Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXJ2SI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXJ2SI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbXJ2SIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:08:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35697 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbXJ2SIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:08:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kirill Korotaev <dev@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] pidns: Limit kill -1 and cap_set_all
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
	<alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
	<m1r6jhzmov.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5p9zk6b.fsf_-_@ebiederm.dsl.xmission.com>
	<47259BE9.4050904@openvz.org>
Date: Mon, 29 Oct 2007 12:07:29 -0600
In-Reply-To: <47259BE9.4050904@openvz.org> (Kirill Korotaev's message of "Mon,
	29 Oct 2007 11:38:01 +0300")
Message-ID: <m1d4uxpzfi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev <dev@openvz.org> writes:

> I dislike this patch:
> it's not scalable/efficient to travers all the tasks
> while we know the pid namespace we care about.

Well the unix way is to implement it simple and stupid and then to
optimize, where needed.  We don't currently have a per pid namespace
list of processes or tasks.

This is a trivial bug fix patch, and I wanted the review to be as
simple as possible.

I don't expect people are doing kill -1 all that frequently as it is a
bit rude.

I have no problem doing find_ge_pid and then looking in the hash table
like we do in /proc.  It likely will have fewer conflicts, but that
is a bit harder to review, and is actually more code.

Eric
