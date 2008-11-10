Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYKJNxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYKJNxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYKJNxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:53:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbYKJNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:53:30 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua>
	<20081110104423.GA26778@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 10 Nov 2008 08:51:18 -0500
In-Reply-To: <20081110104423.GA26778@kernel.dk> (Jens Axboe's message of "Mon,
	10 Nov 2008 11:44:24 +0100")
Message-ID: <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Sun, Nov 09 2008, Vitaly V. Bursov wrote:
>> Hello,
>> 
>> I'm building small server system with openvz kernel and have ran into
>> some IO performance problems. Reading a single file via NFS delivers
>> around 9 MB/s over gigabit network, but while reading, say, 2 different
>> or same file 2 times at the same time I get >60MB/s.
>> 
>> Changing IO scheduler to deadline or anticipatory fixes problem.
>> 
>> Tested kernels:
>>   OpenVZ RHEL5 028stab059.3 (9 MB/s with HZ=100, 20MB/s with HZ=1000
>>                  fast local reads)
>>   Vanilla 2.6.27.5 (40 MB/s with HZ=100, slow local reads)
>> 
>> Vanilla performs better in worst case but I believe 40 is still low
>> concerning test results below.
>
> Can you check with this patch applied?
>
> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view

Funny, I was going to ask the same question.  ;)  The reason Jens wants
you to try this patch is that nfsd may be farming off the I/O requests
to different threads which are then performing interleaved I/O.  The
above patch tries to detect this and allow cooperating processes to get
disk time instead of waiting for the idle timeout.

Cheers,

Jeff
