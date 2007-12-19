Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXLSQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXLSQrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXLSQrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:47:04 -0500
Received: from rtr.ca ([76.10.145.34]:3664 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXLSQrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:47:03 -0500
Message-ID: <47694B06.6090407@rtr.ca>
Date: Wed, 19 Dec 2007 11:47:02 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com>
In-Reply-To: <4768973C.8020909@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Mark Lord wrote:
>> But.. pity there's no mount flag override for smaller systems,
>> where bind mounts might be more useful with link(2) actually working.
> 
> I don't see it.  You always can make hard link on the underlying 
> filesystem.  If you need to make it on the bound mount, that is, if you 
> can't locate the underlying filesystem to make the hard link, you can 
> use a symbolic link.
..

Where people run into trouble with this, is when they simply go to
move a huge file (DVD image) from one directory to another,
where the target happens to be on a different bind point of the
same underlying filesystem.

This can happen in a variety of common ways, including accessing
over CIFS or Samba.

And the result is a very very long delay while we copy 4-8GB of data
instead of simply moving the link.

Cheers
