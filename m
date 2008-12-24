Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbYLXMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbYLXMMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 07:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYLXMML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 07:12:11 -0500
Received: from www.tglx.de ([62.245.132.106]:59241 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYLXMMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 07:12:10 -0500
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
	<20081223115428.GB1439@ucw.cz>
	<864p0u202o.fsf@johno-ibook.fn.ogness.net>
	<20081224085300.GA1539@ucw.cz>
Date: Wed, 24 Dec 2008 13:11:29 +0100
In-Reply-To: <20081224085300.GA1539@ucw.cz> (Pavel Machek's message of "Wed\, 24 Dec 2008 09\:53\:01 +0100")
Message-ID: <86d4fhwz66.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-12-24, Pavel Machek <pavel@suse.cz> wrote:
>> If you are aware of a race condition in DazukoFS, please report
>> it. Thank you.
>
> I'm surprised, do you claim there is none?

It depends on how you want to define "race condition". DazukoFS (in
its current form) closes as many holes as default UNIX permissions or
SElinux. However, changing permissions (i.e. scanning files) _after_
two parties already have an open handle to the file is currently not
covered. But this issue is not unique to DazukoFS (although as a
stackable filesystem, DazukoFS could support this case as well).

> So how do you handle mmap(...MAP_SHARED) case?

DazukoFS currently does not support writing to memory mapped files for
this very reason. It needs to be determined how writing to memory
mapped files should be handled. I am choosing to tackle this issue
together with the Linux kernel community, rather than trying to solve
it within the much smaller Dazuko community.

Although memory mapped writing is currently not supported, I believe
DazukoFS still offers value to the Linux kernel. I am not aware of any
network services that require memory mapped writing for their sharing.

John Ogness
