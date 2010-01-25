Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0AYQY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0AYQY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446Ab0AYQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:24:55 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:41496 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0AYQYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nQRMSQcgIni5y3DUgBAik0Z/8F0mhJ/cq8iEiY+hZZKfe0nNoVxroNDdKhAICHFMt6
         L7dKKoehRrPuQLLqQzdCXtID+UgTIj6J591mvcQXFdjqRY/qruBaKHghso1XMax8/RZ3
         YruLUp5dlOD3h9nPcEsAoPcVkltw5eO9VbgPk=
Date: Tue, 26 Jan 2010 00:26:47 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: zhou peng <ailvpeng25@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Casey Schaufler <casey@schaufler-ca.com>, sds@tycho.nsa.gov,
       jra@samba.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: About ACL for IPC Object
Message-ID: <20100125162647.GC3749@hack>
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com> <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com> <4B57C3C3.9010606@schaufler-ca.com> <20100121090510.GA908@infradead.org> <6fb445941001220115y6b99f7b4g306ea23d3202969@mail.gmail.com> <2375c9f91001220202m724e2ee2p2213b81a043ebd33@mail.gmail.com> <6fb445941001250721p73795fe2i9196bd3c77dd0fce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fb445941001250721p73795fe2i9196bd3c77dd0fce@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:21:44PM +0800, zhou peng wrote:
>I have tested posix sem,posix shm and posix msg queue for ACL on
>fedora 12 with kernel 2.6.32.
>
>Posix sem and posix shm using tmpfs monted by default support ACL well .
>Posix msg queue use mqueue fs mounted by manual but it seem not
>surpoort ACL well. It failed for setting named ACL item:
>{
> $ mkdir /dev/mqueue
> $ mount -o rw, acl -t mqueue none /dev/mqueue
> $cd /dev/mqueue
> "/mq" msg queue object created and used by processes properly
>
> $getfacl mq
>   #file: mq
>   #owner:root
>   #group:root
>   user:rw-
>   group::---
>   other::---
>
> $setfacl -m u:testuser:rw mq                                   /* failed here*/
> $setfacl: mq :Operation not supported
> but mqueue fs works well for setting owner user and owner group items.
>}
>
>I am not sure whether mqueue don't support acl or I make mistake.
>

A quick look at the source code shows mqueue doesn't support ACL.


-- 
Live like a child, think like the god.
 
