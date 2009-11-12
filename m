Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbZKLMme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbZKLMme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZKLMme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:42:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:51453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbZKLMmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:42:33 -0500
Date: Thu, 12 Nov 2009 13:42:38 +0100
From: Jan Kara <jack@suse.cz>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: warn on lookup_one_length/vfs_quota_on_mount
Message-ID: <20091112124238.GH14528@duck.suse.cz>
References: <195c7a900911112329v7df8e718s5c0a5babdea39b99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195c7a900911112329v7df8e718s5c0a5babdea39b99@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Thu 12-11-09 08:29:06, Bastien ROUCARIES wrote:
> I get the following warm on my reiserfs disk with quota enabled at
> boot (each boot) see
> http://www.kerneloops.org/raw.php?rawid=937752&msgid=
> *lookup_one_len
> ? lookup_one_len
> ? lookup_one_len
> ? warn_slowpath_common
> ? lookup_one_len
> ? vfs_quota_on_mount
> ? finish_unfinished
> ? reiserfs_remount
> ? __filemap_fdatawrite_range
> ? do_remount_sb
> ? do_mount
> ? sys_mount
> ? system_call_fastpath
> 
> But it seems a generic bug in the quota layer due to:
> http://www.kerneloops.org/oops.php?number=799645
> http://www.kerneloops.org/oops.php?number=700122
  OK, this shouldn't lead to any real bug (since we look them up during
filesystem mount or remount read-write when noone can mess with the root
directory). But it's probably good to silence the warning by proper locking
anyway. I'll do it. Thanks for the report!

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
