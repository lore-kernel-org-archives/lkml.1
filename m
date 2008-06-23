Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYFWCNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYFWCNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYFWCNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:13:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:51152 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYFWCNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=f2Hpmlgy1397S9dVQdFHQ2Ziz50uH83dhB0/S5D8w3sjuYSLfhAC7QaajYzixOQzIe
         YKI+YStyHoXWUrykleWIlWHAOisumqRoXgfNotn2AEd2hmjCN/utuHi88Jdswqv/zIRS
         Zj33zASDVyYttRcr7EFbv7TgE4ii4mmUtWYj0=
Message-ID: <485F06B8.6090902@gmail.com>
Date: Mon, 23 Jun 2008 11:13:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 07/11] sysfs: Implement sysfs_delete_link and sysfs_rename_link
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.153832341@theryb.frec.bull.fr>
In-Reply-To: <20080618170731.153832341@theryb.frec.bull.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery wrote:
> sysfs: Implement sysfs_delete_link and sysfs_rename_link
> 
> When removing a symlink sysfs_remove_link does not provide
> enough information to figure out which tagged directory the symlink
> falls in.  So I need sysfs_delete_link which is passed the target
> of the symlink to delete.
> 
> Further half the time when we are removing a symlink the code is
> actually renaming the symlink but not doing so explicitly because
> we don't have a symlink rename method. So I have added sysfs_rename_link
> as well.
> 
> Both of these functions now have enough information to find a symlink
> in a tagged directory.  The only restriction is that they must be called
> before the target kobject is renamed or deleted.  If they are called
> later I loose track of which tag the target kobject was marked with
> and can no longer find the old symlink to remove it.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>

Ugly but given the current interface limitations...

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
