Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZFZXWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZFZXWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZFZXWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:22:03 -0400
Received: from mail.open.by ([193.232.92.17]:53884 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbZFZXWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:22:02 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8849 [Jun 27 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sat, 27 Jun 2009 02:23:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090626232339.GD3858@localdomain.by>
References: <20090626143652.GB6281@localdomain.by>
 <20090626144949.GA24173@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626144949.GA24173@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 07:49), Greg KH wrote:
> We've been through this before (search lkml archives).  If kvasprintf
> fails, then we don't want to free old_name, as the caller might want to
> do something with it.
> 
> Or something along those lines, I can't remember the exact reasoning
> this early in the morning.
> 
> Kay, do you remember?
>
I found.
http://lkml.org/lkml/2009/5/11/11

>kobject with name set before should not come into this function,
>kobject_rename should be used instead.

It's just would be safer to kfree or restore I guess.
 
> thanks,
> 
> greg k-h
> 

	Sergey
