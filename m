Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbZDBPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbZDBPhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZDBPhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:37:33 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:29810 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751653AbZDBPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:37:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sEXILLhWyt+gXOkl9MBOaJCjvw7gPR87ClJpeMpKzk76BKqICZBkTEp2BMo/dCNImg9F591bAYUS07P25LkBZDOzk3JT5fPpPE9o9h+hqlI7+8B3TaIf2dPZ/P7xz81S+HW4djRE0z1m0A7Fi2TBh/n7cmR0z+18/Gl+SiMSVmk=  ;
X-YMail-OSG: ON56LdQVM1kxSlySI3l_yDEKUNhU8pig7rAagkEcMzvQbwrEcc.4zV13X3kokeq3aoh58E6YVG2na7FmpaYZyfW_KWRa59cedGGfDakrwJPOEZVKCm9Y9j8baM3yXMgrf8MCsw4mW2Zb5Nu9sROz92gLd2uda0hvxS5aICXl2Z3wSo4tuTsjc8WgMxfqBIKALuqCufB_EoJw3GDSJBuHYspu7cELQV1w1eE4D62tIGRnC7wFY0q4Cu0oSGp8bFLggSnNiaLlCV0fvbnmMfbhisaQGuzkSpUQBfiXwQNPpDCZFoNpSd7l
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 23/43] CacheFiles: Permit the page lock state to be monitored [ver #46]
Date: Fri, 3 Apr 2009 02:37:25 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230520.28177.61387.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230520.28177.61387.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030237.25893.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009 10:05:20 David Howells wrote:
> Add a function to install a monitor on the page lock waitqueue for a particular
> page, thus allowing the page being unlocked to be detected.
> 
> This is used by CacheFiles to detect read completion on a page in the backing
> filesystem so that it can then copy the data to the waiting netfs page.

I prefer to nack this because it is exporting details of the page
locking mechanism. unlock_page is very heavyweight in large part
because of the memory barriers and cacheline required to check the
waitqueue. I have patches to avoid all that if the page lock is
not contended.

What's wrong with using wait_on_page_locked, like everyone else does?
