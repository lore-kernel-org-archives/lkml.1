Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXIYIim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXIYIim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXIYIif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:38:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:34665 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbXIYIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FSHG73h76HAlB7Z9WfvIKdfteJnxua6QzjDj1+eRdJWjgP/SIXWMbARHvGi1opaH+uCOftS6o1KEJdrV8IcQtlsdSCv1ut3jHXS3GxoLus943gtoN/eGYDpUs3/wMy7nWgfYFtgwqkuLAl53529U7Ek9RdNt7rpmR4gEQ0+FDJs=
Message-ID: <46F8C8AA.3030803@gmail.com>
Date: Tue, 25 Sep 2007 17:36:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>	 <1190677332.27805.229.camel@localhost.localdomain>	 <46F86727.4050004@gmail.com>	 <1190686320.27805.258.camel@localhost.localdomain>	 <46F874DB.5070205@gmail.com>	 <1190690493.27805.263.camel@localhost.localdomain>	 <46F8822D.2010003@gmail.com> <1190695118.27805.307.camel@localhost.localdomain> <46F8C5ED.6060101@gmail.com>
In-Reply-To: <46F8C5ED.6060101@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Rusty Russell wrote:
>> Now, are you sure that calling cleanup_ccwgroup just after
>> device_unregister() works?
>>
>> static void __exit
>> cleanup_ccwgroup (void)
>> {
>> 	bus_unregister (&ccwgroup_bus_type);
>> }
> 
> It should.  After ->exit() is called, there can't be any object left
> behind.  If a module is hosting objects which can't be destroyed from
> ->exit(), its module ref count shouldn't be zero.  So, either 1.
> refcount != 0 or 2. ->exit() can destroy all objects.  As Cornelia
> explains, for ccwgroup, it's #1.  Note that unload inhibition doesn't
> change anything about this.

Hmmm.... There doesn't seem to any reason why the blocking should be
after calling ->exit().  And, yeah, it would be more useful and
intuitive if blocking happens before ->exit().  What do you think?

Thanks.

-- 
tejun
