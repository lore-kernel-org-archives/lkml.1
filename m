Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZDMLUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZDMLUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 07:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZDMLT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 07:19:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42012 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbZDMLT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 07:19:57 -0400
Message-ID: <49E31F9B.3030602@redhat.com>
Date: Mon, 13 Apr 2009 14:18:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain> <49E21E8A.2040005@gmail.com> <alpine.LFD.2.00.0904121012500.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904121012500.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The hardware sector size is very different. If you have a 32kB hardware 
> sector size, that implies that _all_ IO has to be done with that 
> granularity. Now you can no longer treat the eight pages as individual 
> pages - you _have_ to write them out and read them in as one entity. If 
> you dirty one page, you effectively dirty them all. You can not drop and 
> re-allocate pages one at a time any more.
>   

You can still drop clean pages.  Sure, that costs you performance as 
you'll have to do re-read them in order to write a dirty page, but in 
the common case, the clean pages around would still be available and 
you'd avoid it.

Applications that randomly write to large files can be tuned to use the 
disk sector size.  As for the rest, they're either read-only (executable 
mappings) or sequential.

-- 
error compiling committee.c: too many arguments to function

