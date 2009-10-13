Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbZJMONw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbZJMONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZJMONv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:13:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:60448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbZJMONu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:13:50 -0400
Message-ID: <4AD48AF6.1010700@suse.com>
Date: Tue, 13 Oct 2009 10:13:10 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel andr <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hfs: fix oops on mount with corrupted btree extent records
References: <4AD3CCC1.9020102@suse.com> <14762.1255407123@turing-police.cc.vt.edu>
In-Reply-To: <14762.1255407123@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 12:12 AM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 12 Oct 2009 20:41:37 EDT, Jeff Mahoney said:
>>  A particular fsfuzzer run caused an hfs file system to crash on mount. This
>>  is due to a corrupted MDB extent record causing a miscalculation of
>>  HFS_I(inode)->first_blocks for the extent tree. If the extent records
>>  are zereod out, it won't trigger the first_blocks special case. Instead
>>  it falls through to the extent code which we're still in the middle
>>  of initializing.
>>
>>  This patch catches the 0 size extent records, reports the corruption,
>>  and fails the mount.
> 
> Just for completeness - does the current fsck.hfs already know how to fix it, or
> at least heave stuff over the side so the filesystem is self-consistent again?
> Or will a user who hits this need a new fsck.hfs to get it back to mountable?

Sorry, I don't actually know. We don't ship a fsck.hfs so I haven't
tested it.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
