Return-Path: <linux-kernel-owner+w=401wt.eu-S1030637AbXAZOk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030637AbXAZOk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030635AbXAZOk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:40:57 -0500
Received: from ms-smtp-02.southeast.rr.com ([24.25.9.101]:60670 "EHLO
	ms-smtp-02.southeast.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030626AbXAZOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:40:56 -0500
Message-ID: <45BA1359.7020200@redhat.com>
Date: Fri, 26 Jan 2007 09:42:33 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Kirill Korotaev <dev@openvz.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] have pipefs ensure i_ino uniqueness by calling iunique
 and hashing the inode
References: <200612291911.kBTJBLvx019107@dantu.rdu.redhat.com> <45B9F939.8070701@openvz.org>
In-Reply-To: <45B9F939.8070701@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
 > Jeff,
 >
 > is 100% uniqeness is so much required for pipe inode numbers?
 > AFAIU, it is not that critical for pipefs (unlike smb, nfs etc.)
 >
 > Thanks,
 > Kirill
 >

There is no in-kernel reason why i_ino uniqueness is important for
pipefs. Where it might matter is userspace. The i_ino value is used for:

1) the st_ino value returned in stat calls

2) the dentry name (generated as "[inode_number]")

So while it's certainly not "correct" to have multiple inodes with the same
number on any filesystem, it is probably more important in some places is
others. For pipefs, maybe it isn't, especially given a potential 6% performance
impact to fix it. Anyone else have thoughts?

-- Jeff

