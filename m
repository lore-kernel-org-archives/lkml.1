Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZEBSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZEBSUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZEBSUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 14:20:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45945 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZEBSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 14:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=chVbZJ+QQDJqjKcHjzFZnRCHYvp+tZvniiKk60BqV5JgFVu+whA0zl6dhXDWztuRDj
         x9N/1J2ZDfKXJCFiVWFG2PBei0YS7ALvbourwGHvEqfsBrQAa/1fsVb0j1bU7yKDTvQt
         upxci9hKwn9/ReKh6u9Zq3jngwmy38SdBYZY8=
Message-ID: <49FC8EE4.6040408@googlemail.com>
Date: Sat, 02 May 2009 20:20:20 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 	<20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk> 	<ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com>
In-Reply-To: <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Kay Sievers wrote:
> On Fri, May 1, 2009 at 15:18, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>>No tool ever has a chance to get to the information only available at
>>>early kernel init. All such tools will need to "replay" what the
>>>kernel already did. This is intended to save us from doing this, and
>>>retain the information which is there, but lost at the moment the
>>>tools have the first chance to run.
>>
>>Serious question - which is the better problem to fix ?
> 
> 
> I'm very sure, you can not fix it outside the kernel. Or do you have
> an idea how to create the missing device nodes for device without
> crawling sysfs, when the first userspace process is started?

Well, what about this? Let the kernel buffer all events until udev is
ready to process them. Once it signals that it's up and running - the
best method for that is tbd -, empty the queue, and then discard it,
including the additional code. If udev doesn't come up in time after
init has started, or the buffer overflows, assume the system is using a
static /dev and throw away the queue as well. If udev starts too late,
it can still do a coldplug - in that case, boot speed is already so low
that the additional delay hardly matters.

Comments?

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
