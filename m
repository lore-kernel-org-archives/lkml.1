Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZBWJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZBWJWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZBWJWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:22:05 -0500
Received: from cuda1.bluetone.cz ([212.158.128.5]:45803 "EHLO mail.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZBWJWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:22:04 -0500
Message-ID: <49A26ACC.90804@slax.org>
Date: Mon, 23 Feb 2009 10:22:20 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/8] Aufs2: structure
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org>
In-Reply-To: <49A268A7.1010708@slax.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The struct of a xino file is simple, just a sequence of aufs inode
> numbers which is indexed by the lower inode number.
> In the above sample, assume the inode number of /ro/fileA is i111 and
> aufs assigns the inode number i999 for fileA. Then aufs writes 999 as
> 4(8) bytes at 111 * 4(8) bytes offset in the xino file.

I think it is worth mentioning that the xino file, if I understand it correctly, is a 'sparse file', that means it is full of 'holes' and doesn't consume as much disk space as it might appear.

In my opinion, the current xino-file approach is not much usable on filesystems which do not support sparse files (for example, if you wish to union two vfats), since some 'seeks' would probably write a lot of nulls. But I am not any kernel developer so I don't even know if there exists any filesystem which would be unable to support sparse files (except the mentioned VFAT, of course).


Tomas M
slax.org
