Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYLBRXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYLBRXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYLBRXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:23:12 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:45678 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbYLBRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:10 -0500
Message-ID: <49356EF2.7060806@nortel.com>
Date: Tue, 02 Dec 2008 11:22:58 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Pavel Machek <pavel@suse.cz>, mikulas@artax.karlin.mff.cuni.cz,
       clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
In-Reply-To: <20081202163720.GB18162@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2008 17:23:03.0145 (UTC) FILETIME=[A1B8D590:01C954A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:

> Even for ext3/ext4 which is doing physical journalling, it's still the
> case that the journal commits first, and it's only later when the
> write happens that we write out the change.  If the disk fails some of
> the writes, it's possible to lose data, especially if the two blocks
> involved in the node split are far apart, and the write to the
> existing old btree block fails.

Yikes.  I was under the impression that once the journal hit the platter 
then the data were safe (barring media corruption).

It seems like the more I learn about filesystems, the more failure modes 
there are and the fewer guarantees can be made.  It's amazing that 
things work as well as they do...

Chris
