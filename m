Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZBSKNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZBSKNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZBSKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:13:34 -0500
Received: from welcomes-you.com ([85.214.50.128]:39386 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZBSKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:13:34 -0500
Message-ID: <499D30B1.30802@aei.mpg.de>
Date: Thu, 19 Feb 2009 11:13:05 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de
Subject: Re: xfs problems (possibly after upgrading from linux kernel	2.6.27.10
 to .14)
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed> <499BD6BB.2000406@aei.mpg.de> <20090219061925.GE8830@disturbed>
In-Reply-To: <20090219061925.GE8830@disturbed>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Dave Chinner schrieb:
>> I can try doing that on a few machines, would a metadump help on a
>> machine where this corruption occurred some time ago and is still in
>> this state?
> 
> If you unmount the filesystem, mount it again and then touch a new
> file and it reports the error again, then yes, a metadump woul dbe
> great.
> 
> If the error doesn't show up after a unmount/mount, then I
> can't use a metadump image to reproduce the problem.
> 

I've done it on two nodes so far and the result is not good (metadump wise):
[1344887.778232] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344887.778432] xfs_force_shutdown(sda6,0x1) called from line 420 of
file fs/xfs/xfs_rw.c.  Return address = 0xffffffff8031dd7e
[1344889.579836] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.580044] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.580257] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.580450] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.624774] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344915.783844] XFS mounting filesystem sda6
[1344915.872333] Starting XFS recovery on filesystem: sda6 (logdev:
internal)
[1344917.399834] Ending XFS recovery on filesystem: sda6 (logdev: internal)

After that I can touch/create all files I want on the fs again.

> I suspect so. We've already had XFS trigger one bug in the new
> lockless pagecache code, and the fix for that went in 2.6.27.11 -
> between the good version and the version that you've been seeing
> these memory corruptions on. I'm wondering if that fix exposed or
> introduced another bug that you've hit....
> 
> Nick?

If it was triggered by a user job, it might have been in the kernel for
longer and the user just did not run it for a few weeks.

I'll try to gather more information.

Cheers

Carsten
