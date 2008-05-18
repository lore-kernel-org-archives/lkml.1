Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYESAYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYESAYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYESAYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:24:16 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58783 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYESAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:24:15 -0400
Date: Sun, 18 May 2008 17:04:35 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: bernie@codewiz.org
Cc: lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       ext3-users@redhat.com, ext2-devel@lists.sourceforge.net,
       Stefano Fedrigo <aleph@develer.com>
Subject: Re: ext3_dx_add_entry: Directory index full!
Message-ID: <20080518210435.GA8335@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, bernie@codewiz.org,
	lkml <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
	ext2-devel@lists.sourceforge.net,
	Stefano Fedrigo <aleph@develer.com>
References: <48304CE2.1090808@codewiz.org> <48304D92.1080306@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48304D92.1080306@develer.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 05:38:58PM +0200, Bernie Innocenti wrote:
> Bernie Innocenti wrote:
>> On 2.6.24.4-64.fc8, I createed and mounted a filesystem like this:
>>   mke2fs -m0 -b 1024 -R stride=64 -I 128 -i 2048 -j  -L mail -O 
>> dir_index,sparse_super -v /dev/sdc1
>
> I cannot reproduce it any more if I reformat omitting "-b 1024".
> Maybe it would reappear with 200K * 4 = 800K files?

Using a filesystem with 4k blocks, and assuming the filenames are of
the same average length, you should be able to get approximately 200k
* (4**3) = 12.8 million files in a single directory.  If you use a 2k
block filesystem, the limit will be approximately 200k * (2**3) = 1.6
million files in a single directory.

Regards,

						- Ted

P.S.  Past a certain point, you really don't want to have that many
files in a Maildir directory; if the user is never going to be
deleting his SPAM, then you should seriously think about using a Unix
mbox style storage scheme.  Even with a 1k block filesystem, at 12
million files you'll be wasting 6 gigabytes of disk space of slack
space that is totally being wasted since the whole point of using
Maildir is to make it easy to delete or replace individual mail
messages.  If you want to archive all of your SPAM, why use a Maildir
format mbox at all?
