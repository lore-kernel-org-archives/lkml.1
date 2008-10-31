Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJaDNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJaDNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYJaDNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:13:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2980 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYJaDNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Qy3ORi1adkVvQWtijpIdqlx7ut0NQ1/nlSeaj8cYMvIfk5VYsGxHG19uC/6FC72LvM
         +/ldW6/sMiPWgtEnSgqgrjB3HmC+UrG5asLsr2cxKxeK/NJlJUIymgSUU8qQOamhgOcI
         9DKffSBsqehEGjqMmKm1hmdJowZl+0tbhYmH4=
Message-ID: <524f69650810302013t76027b12i105214daf651ce6a@mail.gmail.com>
Date: Thu, 30 Oct 2008 22:13:43 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: mmotm 2008-10-30-02-23 uploaded (cifs)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Jeff Layton" <jlayton@redhat.com>
In-Reply-To: <20081030181427.bad789f5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810300924.m9U9OPqK030938@imap1.linux-foundation.org>
	 <20081030181427.bad789f5.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 8:14 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 30 Oct 2008 02:24:25 -0700 akpm@linux-foundation.org wrote:
>
>> The mm-of-the-moment snapshot 2008-10-30-02-23 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> It contains the following patches against 2.6.28-rc2:
>
> fs/cifs/connect.c: In function 'cifs_mount':
> fs/cifs/connect.c:2180: error: request for member 'sin_addr' in something not a structure or union
>
> rand-config attached.

These line numbers don't match anywhere close to what I expect to find
in -mm based on the contents of fs/cifs in cifs-2.6.git tree.  My
guess is that has a cifs patch from Jeff Layton, not in cifs-2.6.git
which may have other dependencies, and in any case IIRC has since been
removed from -mm but if not that patch may be the problem.

The closest line I have is:

			sprintf(pSesInfo->serverName, "%u.%u.%u.%u",
				NIPQUAD(sin_server.sin_addr.s_addr));

and since sin_server is defined as
   	struct sockaddr_in sin_server;
that should be fine.
-- 
Thanks,

Steve
