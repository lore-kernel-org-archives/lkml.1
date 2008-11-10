Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYKJN56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYKJN56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYKJN5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:57:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46957 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbYKJN5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:57:50 -0500
Date: Mon, 10 Nov 2008 14:56:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081110135618.GI26778@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10 2008, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Sun, Nov 09 2008, Vitaly V. Bursov wrote:
> >> Hello,
> >> 
> >> I'm building small server system with openvz kernel and have ran into
> >> some IO performance problems. Reading a single file via NFS delivers
> >> around 9 MB/s over gigabit network, but while reading, say, 2 different
> >> or same file 2 times at the same time I get >60MB/s.
> >> 
> >> Changing IO scheduler to deadline or anticipatory fixes problem.
> >> 
> >> Tested kernels:
> >>   OpenVZ RHEL5 028stab059.3 (9 MB/s with HZ=100, 20MB/s with HZ=1000
> >>                  fast local reads)
> >>   Vanilla 2.6.27.5 (40 MB/s with HZ=100, slow local reads)
> >> 
> >> Vanilla performs better in worst case but I believe 40 is still low
> >> concerning test results below.
> >
> > Can you check with this patch applied?
> >
> > http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
> 
> Funny, I was going to ask the same question.  ;)  The reason Jens wants
> you to try this patch is that nfsd may be farming off the I/O requests
> to different threads which are then performing interleaved I/O.  The
> above patch tries to detect this and allow cooperating processes to get
> disk time instead of waiting for the idle timeout.

Precisely :-)

The only reason I haven't merged it yet is because of worry of extra
cost, but I'll throw some SSD love at it and see how it turns out.

-- 
Jens Axboe

