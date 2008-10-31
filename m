Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYJaElU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYJaElU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYJaElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:41:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39986 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYJaElF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:41:05 -0400
Message-ID: <490A8C16.6040207@oracle.com>
Date: Thu, 30 Oct 2008 21:39:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Layton <jlayton@redhat.com>
Subject: Re: mmotm 2008-10-30-02-23 uploaded (cifs)
References: <200810300924.m9U9OPqK030938@imap1.linux-foundation.org>	 <20081030181427.bad789f5.randy.dunlap@oracle.com> <524f69650810302013t76027b12i105214daf651ce6a@mail.gmail.com>
In-Reply-To: <524f69650810302013t76027b12i105214daf651ce6a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> On Thu, Oct 30, 2008 at 8:14 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Thu, 30 Oct 2008 02:24:25 -0700 akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2008-10-30-02-23 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> It contains the following patches against 2.6.28-rc2:
>> fs/cifs/connect.c: In function 'cifs_mount':
>> fs/cifs/connect.c:2180: error: request for member 'sin_addr' in something not a structure or union
>>
>> rand-config attached.
> 
> These line numbers don't match anywhere close to what I expect to find
> in -mm based on the contents of fs/cifs in cifs-2.6.git tree.  My
> guess is that has a cifs patch from Jeff Layton, not in cifs-2.6.git
> which may have other dependencies, and in any case IIRC has since been
> removed from -mm but if not that patch may be the problem.
> 
> The closest line I have is:
> 
> 			sprintf(pSesInfo->serverName, "%u.%u.%u.%u",
> 				NIPQUAD(sin_server.sin_addr.s_addr));
> 
> and since sin_server is defined as
>    	struct sockaddr_in sin_server;
> that should be fine.

I can't tell you whether this is in cifs.git, but the erring lines are:

		tcon =
		    find_unc(sin_server.sin_addr.s_addr, volume_info.UNC,
			     volume_info.username);

where sin_server.sin_addr should be sin_server->sin_addr.

HTH.
-- 
~Randy
