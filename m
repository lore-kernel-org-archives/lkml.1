Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZEUHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZEUHlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZEUHlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:41:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZEUHlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:41:04 -0400
Message-ID: <4A150587.5080104@kernel.org>
Date: Thu, 21 May 2009 16:40:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 06/20] sysfs: Use dentry_ops instead of directly playing
 with the dcache
References: <m1bppofm9k.fsf@fess.ebiederm.org>	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>	<1242865694-2100-5-git-send-email-ebiederm@xmission.com>	<1242865694-2100-6-git-send-email-ebiederm@xmission.com>	<4A14F781.6010103@kernel.org> <m1k54a6h51.fsf@fess.ebiederm.org>
In-Reply-To: <m1k54a6h51.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 07:40:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> Ummm... what happens if sysfs recreates those identical nodes again
>> while the old dentries are lingering?  The dead ones will linger till
>> the submounts are gone and then look ups after that will show the new
>> ones, right?
> 
> Yep.  On the vfs level.  The sysfs dirent tree will reflect what is
> going on with the hardware.
> 
> This is a vfs misfeature, that I hope someday we will get fixed.
> But for now it is better not to leak mount points.  Especially
> since no one actually mounts things on sysfs.

fuse and debugfs do.  :-P

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
