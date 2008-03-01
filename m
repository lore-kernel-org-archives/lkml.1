Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbYCAPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbYCAPpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYCAPpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:45:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:59258 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbYCAPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:45:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=xCutZZ/tNmT29lABr0LdPx9HzNZDfY7Wj44LbMBJXybiFarwsspoTQIpF3tOhj1riWTPFfn+kpWDG3PLK5qRkKd+BLQpafJ0+renq053mf/MU3tg16AIz3qwqbafF07eftHR5hwvOvQ+cwcf0i0I8GYi/WrJZf0wCcYJO5KTXMs=
Date: Sat, 1 Mar 2008 16:45:29 +0100
To: Jens Axboe <jens.axboe@oracle.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] ide-tape: remove pipelined mode operation
Message-ID: <20080301154529.GB30547@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Jens Axboe <jens.axboe@oracle.com>,
	bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <20080301095518.GW6704@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080301095518.GW6704@kernel.dk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 10:55:18AM +0100, Jens Axboe wrote:
> On Sat, Mar 01 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's the 1st draft of the pipeline removal series. As the diffstat below openly
> > states it, a lot of code got removed - even more than the cleanup series we did
> > earlier. There are several issues that we need to address concerning these
> > patches:
> > 
> > 1. only compile-tested since i don't have the hardware, i.e. longer -mm brewing is
> > advisable the least.
> > 
> > 2. I have left the tape->merge_stage buffer structure along with its
> > alloc/free functions intact for now, for simplicity. The next step would be
> > to go and carefully audit the code and then remove that last piece
> > too and use allocations on the stack instead. I guess we still expect
> > Jens's response on whether blk_{get,put}_request is the way to go here.
> > 
> > Jens?
> 
> Hm, I have not seen any questions regarding this directed my way :-)
> Please point me to the original question and I'll take a look at it.

Hi Jens,

sorry but maybe we weren't that explicit, here's a pointer to the relevant
thread: http://www.mail-archive.com/linux-ide@vger.kernel.org/msg15541.html. It
boils down to removing the statically allocated arrays of buffers for pc and rq
structs in ide-floppy and ide-tape, and using GFP_ATOMIC stack memory instead.
Bart's idea was to even go a step further and even avoid allocation errors in
out-of-mem situations by reusing requests from the request queue but wasn't sure
whether this'll fly and wanted to run it by you...

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
