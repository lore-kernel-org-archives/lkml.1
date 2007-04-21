Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXDUIFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXDUIFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXDUIFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:05:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXDUIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:05:34 -0400
Message-ID: <4629C4F6.5070907@zytor.com>
Date: Sat, 21 Apr 2007 01:01:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 2/8] allow unprivileged umount
References: <20070420102532.385211890@szeredi.hu>	<20070420102626.825263599@szeredi.hu> <20070421005506.6a315bec.akpm@linux-foundation.org>
In-Reply-To: <20070421005506.6a315bec.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Apr 2007 12:25:34 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
>> +static bool permit_umount(struct vfsmount *mnt, int flags)
>> +{
>>
>> ...
>>
>> +	return mnt->mnt_uid == current->uid;
>> +}
> 
> Yes, this seems very wrong.  I'd have thought that comparing user_struct*'s
> would get us a heck of a lot closer to being able to support aliasing of
> UIDs between different namespaces.
> 

Not to mention it should be fsuid, not uid.

	-hpa
