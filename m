Return-Path: <linux-kernel-owner+w=401wt.eu-S936256AbXHHQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936256AbXHHQmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXHHQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:42:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbXHHQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Cp7x5hh6JHsm1JW38grIpOIirn9VGXZlqU+cJ3uSnbtCIyYG61N9XKfwcY4IOYGDnqvV77X14n52jt40samnlQSpWR3a0gk+uCj5bjwGt7w7p8c+a6HYgvVugbsylWVF9XrqdeumJpBYTgnBQJEuYux0CX9IwcvsmANZ76zk1EE=
Message-ID: <46B9F25B.6020804@gmail.com>
Date: Thu, 09 Aug 2007 01:42:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 20/25] sysfs: Rename Support multiple superblocks
References: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>	<m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>	<m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com>	<m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com>	<m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>	<m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>	<m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>	<20070808093505.GL13674@htj.dyndns.org>	<m1643qdo7e.fsf@ebiederm.dsl.xmission.com>	<46B9E660.6030702@gmail.com> <m1lkcmc7c5.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lkcmc7c5.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> 	/* Find the first parent which has valid dentry.
>> 	 */
>> 	dentry = NULL;
>> 	cur = sd;
>> 	while (!(dentry = __sysfs_get_dentry(sb, cur))) {
>> 		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
>> 			dentry = ERR_PTR(-ENOENT);
>> 			break;
>> 		}
>> 		cur = cur->s_parent;
>> 	}
> 
> Here we depend on the fact that sysfs_root is pointed to
> by sb->s_root so we know it will always have a dentry.

Hmmm... dentry could be ERR_PTR(-ENOENT) here if the REMOVED flag test
succeeded, right?

>> 	/* from the found dentry, look up depth times */
>> 	while (dentry->d_fsdata != sd) {

And then dereferenced.  The REMOVED test should never succeed there, so
we're probably in the clear but still the code looks a bit scary.

-- 
tejun
