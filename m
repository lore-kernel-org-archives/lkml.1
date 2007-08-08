Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbXHHPvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbXHHPvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXHHPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:51:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:31494 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXHHPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=b3HaeNNRw/DiTX/Pv0Q3jBqk/CD3QeZ8twTHNpoGBxUpSHT9bYuIq5hnzJhqXIcweOx0fIXUhbGDNqz/ewxfhPhBKN0U6siSR0NNzG00e59HcFn9L6uLEcHhcJKPOjiUOBcG0qtP06GQOjZp5zyJQ6aJf/DjBedyYV6rJNJzdBc=
Message-ID: <46B9E660.6030702@gmail.com>
Date: Thu, 09 Aug 2007 00:50:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 20/25] sysfs: Rename Support multiple superblocks
References: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>	<m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>	<m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com>	<m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com>	<m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>	<m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>	<m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>	<20070808093505.GL13674@htj.dyndns.org> <m1643qdo7e.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1643qdo7e.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Welcome.  I will see what I can do with respect to cleaning up
> the names.
> 
> As for the return value of sysfs_get_dentry that is tricky.  In particular
> I have three specific cases the code needs to deal with.
> 
> - We got the dentry.
> - We did not get the dentry because for this super block there never
>   ever will be a dentry.
> - Some kind of error occurred in attempting to get the dentry.
> 
> Not getting a dentry because it is impossible I am currently handling
> with a NULL return.  I can equally use a specific error code to mean
> that as well.  It doesn't much matter.  So I guess the hunk in
> question could read:
> 
>>> +	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
>>> +		dentry = sysfs_get_dentry(sb, sd);
>>> +		if (dentry == ERR_PTR(-ENOENT))
>>> +			continue;
> 
> As long as we handle that class of error differently I really don't
> care.

Yeah, I think using -ENOENT is better; otherwise, my little head feels
like exploding.  :-)  More importantly, sysfs_get_dentry() seems like it
would deference ERR_PTR() value.  No?

-- 
tejun
