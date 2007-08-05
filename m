Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXHEMYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXHEMYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXHEMYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:24:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36824 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbXHEMYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:24:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Kirill Korotaev <dev@openvz.org>, lkml <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>, Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: CLONE_NEWIPC documentation
References: <46B599D8.8010003@gmx.net>
Date: Sun, 05 Aug 2007 06:24:05 -0600
In-Reply-To: <46B599D8.8010003@gmx.net> (Michael Kerrisk's message of "Sun, 05
	Aug 2007 11:35:20 +0200")
Message-ID: <m1ejiikw4a.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> writes:

> Hello Kirill,
>
> In 2.6.19, your patch to add support for CLONE_NEWIPC was included.  Is
> there there some for-userland-programmers documentation of this flag
> somewhere?  Would you be able to send some documentation to me (ideally as
> a patch to the clone.2 man page, but otherwise some plain text will do).
>
> If this flag is also supported for unshare(), then could you please send me
> a patch/text for that too?

In case someone else doesn't do better here is a short summary.

CLONE_NEWIPC creates a new ipc namespace for the new child and all
of it's children.  So far CAP_SYS_ADMIN is required.

An IPC namespace creates a new context for looking up and listing
SYSV IPC shared memory, message queues, and semaphores.  Only allowing
finding of SYSV IPC objects in this namespace.

For most practical purposes two processes in different SYSV IPC
namespaces might as well be on different machines.  As they cannot
find each others SYSV IPC resources, and so cannot interact with
each other that way.

The implementation is essentially just a lookup of the objects
in a different table when doing name to object translation so
there should be no measurable overhead.

When the last process in a SYSV IPC namespace exits any remaining
objects in that SYSV IPC namespace are destroyed.

Eric
