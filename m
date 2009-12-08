Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZLHJwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZLHJwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZLHJwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:52:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZLHJv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:51:59 -0500
Message-ID: <4B1E2273.6030706@redhat.com>
Date: Tue, 08 Dec 2009 17:54:59 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dan Carpenter <error27.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
Subject: Re: [Patch] selinux: remove a useless return
References: <20091203085127.4370.1737.sendpatchset@localhost.localdomain> <b263e5900912070532i6ab63c36o48030a191c091dd5@mail.gmail.com>
In-Reply-To: <b263e5900912070532i6ab63c36o48030a191c091dd5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> On 12/3/09, Amerigo Wang <amwang@redhat.com> wrote:
>> The last return is unreachable, remove the 'return'
>> in default, let it fall through.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Eric Paris <eparis@parisplace.org>
>>
>> ---
>>
>> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
>> index b5407f1..718823d 100644
>> --- a/security/selinux/ss/mls.c
>> +++ b/security/selinux/ss/mls.c
>> @@ -542,7 +542,7 @@ int mls_compute_sid(struct context *scontext,
>>  		/* Use the process effective MLS attributes. */
>>  		return mls_context_cpy_low(newcontext, scontext);
>>  	default:
>> -		return -EINVAL;
>> +		/* Fallthrough */
>>  	}
>>  	return -EINVAL;
>>  }
> 
> I don't think this compiles.  GCC doesn't let you end a switch block
> with a label.
> 
> I also have sent the selinux people a patch that didn't compile by
> mistake.  Afterward I wrote this script so hopefully I won't mess up
> again.


Oops, sorry for this, my bad.
Thanks for your patch.

> 
> #!/bin/bash -e
> 
> files=$(grep +++ /home/dcarpenter/var/mail/postponed-msgs | cut -f 1 |
> cut -b 5-)
> for file in $files ; do
> 	file=${file/devel\//}
> 	file=${file/new\//}
> 	kchecker $file
> 	if which sparse | grep -q sparse ; then
> 		kchecker --sparse $file
> 	fi
> done
> 
> 
> You will have to change the path names.  Hm....  Also you will have to
> get the kchecker script from the smatch_data/ directory of smatch
> (http://repo.or.cz/w/smatch.git).

Thanks for the info! I will have a try.

