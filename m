Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXDQGcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXDQGcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXDQGcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:32:00 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1455 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXDQGb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:31:59 -0400
Message-ID: <11570.213.222.28.155.1176791453.squirrel@webmail.xs4all.nl>
In-Reply-To: <20070416225748.3e5d3003@the-village.bc.nu>
References: <20070412090809.917795000@suse.de>
    <20070412090846.670863000@suse.de>
    <20070412105825.15f4df39@the-village.bc.nu>
    <200704151940.22528.agruen@suse.de>
    <20070416225748.3e5d3003@the-village.bc.nu>
Date: Tue, 17 Apr 2007 08:30:53 +0200 (CEST)
Subject: Re: [AppArmor 31/41] Fix __d_path() for lazy unmounts and make it 
     unambiguous; exclude unreachable mount points from /proc/mounts
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Andreas Gruenbacher" <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Reply-To: capibara@xs4all.nl
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, April 16, 2007 23:57, Alan Cox wrote:
>> > That is a fairly significant and sudden change to the existing
>> > kernel/user interface.
>>
>> Well, this is not meant for 2.6.21. I hope it is possible to change it
>> in
>> early 2.6.22; otherwise if we can't fix mistakes from the past we are
>> pretty
>> doomed.
>
> I don't believe the existing behaviour _IS_ a mistake.
>
>> > This is untrue. The process can get there (via fd passing with another
>> > task)
>>
>> Process can access file descriptors which are unreachable via path name
>> just
>> fine indeed, but those fds still don't have a valid path in the context
>> of
>> that process.
>
> Which while problematic to your name based security is just fine to
> everything else.

The realisation that I feel needs to be made is that fd passing is a
legitimate transfer of authority, and attempting to block the usage of
this authority (or block the transfer of this authority) would be
extremely bad.

One thing however that does need some major attention is the amounth of
and the scope of the authority that is being transfered with directory
file handles.



