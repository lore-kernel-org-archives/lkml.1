Return-Path: <linux-kernel-owner+w=401wt.eu-S934949AbXGRQls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbXGRQls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbXGRQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:41:39 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:51835 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbXGRQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TDg48jOa5SK3E1fTnzNWoJnKU7QHyrFzaNO7YFhEM6OJtFrUdsLTfJi1GsVvdNq46SjmFDJbyDkvNTLMdE34vJ66ODq+YljLnoTd9Irr4PmlSsG7epXTeOJl20Gf8MIrcuhHX3VFUBCUwzdDO0nhLkuYYEXrnpBdq3wHgoJ4UqI=
Message-ID: <469E42BA.7010601@gmail.com>
Date: Thu, 19 Jul 2007 01:41:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>	 <20070718071445.GI23568@htj.dyndns.org>	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>	 <469E2A68.6010307@gmail.com>	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>	 <469E352A.90909@gmail.com> <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com> <469E401D.2020506@gmail.com>
In-Reply-To: <469E401D.2020506@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Satyam Sharma wrote:
>>>> sysfs_find_dirent() -- to check for -EEXIST -- should be called
>>>> *before* we create the new dentry for the to-be-created symlink
>>>> in the first place. [ It's weird to grab a reference on the target
>>>> for ourselves (and in fact even allocate the new dirent for the
>>>> to-be-created symlink) and /then/ check for erroneous usage,
>>>> and then go about undoing all that we should never have done
>>>> at all. ] So this test could, and should, be made earlier, IMHO.
>>> Locking.
>> Well s/sysfs_find_dirent/sysfs_get_dirent/ then. And then simply put
>> down the reference later.
> 
> Isn't that the current code?

Oops, somehow thought you were talking about allocating it first.
Gee... what difference does using sysfs_get_dirent() make?  Do you think
the following code is correct?

	sd = sysfs_get_dirent("some name");
	if (sd != NULL)
		return -EEXIST;
	lock;
	add_new_node("some name");
	unlock;
	sysfs_put_dirent(sd);

-- 
tejun
