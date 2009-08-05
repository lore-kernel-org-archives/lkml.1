Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbZHECG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbZHECG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933345AbZHECG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:06:58 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:45412 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314AbZHECG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mf4LudBYEGfhgYxxc587g4Hlmo//fBeX7Ch+MevSMeZNN53z3VLhkJ0OdQa1lsVTGb
         7+3aNjl5z7JTtD0tjWGwOAtXecnFN7VK7JOd5fLEOA78D2GK4I8AUzLv4X+aj7B9/9ez
         CseefxTaZ6KsOp5Zd56SYqm4feWmAyhrpzs+0=
Date: Wed, 5 Aug 2009 10:09:08 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Mike Smith <scgtrp@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 2/3] kcore: fix vread/vwrite to be aware of
	holes.
Message-ID: <20090805020818.GA5389@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/> <20090728160527.1da52682.akpm@linux-foundation.org> <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com> <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com> <20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com> <20090803201845.c3ae49b5.kamezawa.hiroyu@jp.fujitsu.com> <20090804092316.GB6451@cr0.nay.redhat.com> <20090804185526.bf592ce1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804185526.bf592ce1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 06:55:26PM +0900, KAMEZAWA Hiroyuki wrote:
>> >+
>> >+/**
>> >+ *	vread() -  read vmalloc area in a safe way.
>> >+ *	@buf:		buffer for reading data
>> >+ *	@addr:		vm address.
>> >+ *	@count:		number of bytes to be read.
>> >+ *
>> >+ *	Returns # of bytes which addr and buf should be increased.
>> >+ *	(same to count).
>> >+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
>> 
>> 
>> If I read it correctly, your code doesn't do what you described here,
>> it doesn't return 0 when there is no valid area.
>> 
>
>Hmm.. valid area is ambiguous, ok, how about this ?
>
>If [addr...addr+count) has no intersects with exisiting vm_struct, returns 0.

Ah, I see your points now, Ok then.

Thanks.
