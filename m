Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXFNKFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXFNKFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXFNKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:05:22 -0400
Received: from max.aladin.ro ([80.96.155.2]:33385 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbXFNKFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:05:20 -0400
Message-ID: <466ECE02.7000707@aladin.ro>
Date: Tue, 12 Jun 2007 19:46:58 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Juergen Beisert <juergen127@kreuzholzen.de>
CC: linux-kernel@vger.kernel.org, lkml@kev009.com
Subject: Re: ext2 on flash memory
References: <20070611101319.GA14284@DervishD> <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net> <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com> <200706120953.03735.juergen127@kreuzholzen.de>
In-Reply-To: <200706120953.03735.juergen127@kreuzholzen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Juergen Beisert wrote:
> So it makes no sense to find the best filesystem for such a case. 
> There is no best one.

It does make sense. Wear leveling isn't the only thing that matters. An
important criteria is the total amount of wear that you get when using a
filesystem. Some filesystems are simply not suitable: they either write
too often to disk (though, as I said, this can be alleviated by COW-ing
it or working on a copy and then updating the flash drive), or a single
operation requires too many changes to its image/structure. Normal fs-s
often change their internal structure, trading for space efficiency or
speed. Better storage and accounting of data involve more complicated
internal fs structures, that aren't too stable over time (that is, they
change often and much).

For example, an ISO9660 multisession rewritable CD/DVD trades space
efficiency and flexibility for a lower wear and better wear-leveling.
This is obvious, as the user triggers flushes to disk (that is, burning
a new session) with a lower frequency, when his work is done, and the
writes are always done sequentially (=> wear leveling). I'm not saying
anything about UDF, since I don't know much about it.

