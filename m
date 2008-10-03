Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYJCPzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYJCPzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYJCPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:55:09 -0400
Received: from M4.sparta.com ([157.185.61.2]:50826 "EHLO M4.sparta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYJCPzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:55:07 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 11:55:07 EDT
Message-ID: <48E63DCA.1050700@sparta.com>
Date: Fri, 03 Oct 2008 11:44:10 -0400
From: "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, hch@infradead.org,
       viro@zeniv.linux.org.uk, casey@schaufler-ca.com, sds@tycho.nsa.gov,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 11/14] NFS/RPC: Add the auth_seclabel security flavor
 to allow the process label to be sent to the server.
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov> <1222707986-26606-12-git-send-email-dpquigl@tycho.nsa.gov> <20081003142342.GA9774@brain>
In-Reply-To: <20081003142342.GA9774@brain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2008 15:44:12.0680 (UTC) FILETIME=[E21AB080:01C9256E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> On Mon, Sep 29, 2008 at 01:06:23PM -0400, David P. Quigley wrote:
> [...]
>>  
>> +	if (dom->flavour != &svcauth_unix
>> +#ifdef CONFIG_SECURITY
>> +	    && dom->flavour != &svcauth_seclabel
>> +#endif
>> +	   )
>>  	if (dom->flavour != &svcauth_unix)
>>  		return -EINVAL;
>>  	udom = container_of(dom, struct unix_domain, h);
>> @@ -873,3 +889,80 @@ struct auth_ops svcauth_unix = {
>>  	.set_client	= svcauth_unix_set_client,
>>  };
> 
> checkpatch picked up on a suspect code indent for this hunk.  It is
> unhappy about the second if expecting it to be indented.  By the looks
> of this I am suspecting a miss-merge of the change in this function and
> the second if should have been removed.  To my reading it actually still
> does the right thing but ...

This does appear to be a miss-merge.
