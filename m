Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZFPMgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZFPMgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZFPMgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:36:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZFPMgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:36:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
References: <4A3075B2.9040208@ct.jp.nec.com>
	<20090611110903.GO11363@kernel.dk>
	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>
	<20090612133014.GK11363@kernel.dk>
	<x49ski5v7vs.fsf@segfault.boston.devel.redhat.com>
	<4A35C0A4.20707@ct.jp.nec.com> <4A3614D1.20403@panasas.com>
	<4A370B3D.4050108@ct.jp.nec.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Jun 2009 08:35:53 -0400
In-Reply-To: <4A370B3D.4050108@ct.jp.nec.com> (Kiyoshi Ueda's message of "Tue,
	16 Jun 2009 12:02:21 +0900")
Message-ID: <x49zlc8cq52.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:

> Hi Boaz, Jeff, Jens,
>
> Thank you for your ideas.
> It's time to decide now?  Please see below.
>
> On 2009/06/15 18:30 +0900, Boaz Harrosh wrote:
>> > On 06/15/2009 06:31 AM, Kiyoshi Ueda wrote:
>>> >> On 06/12/2009 11:33 PM +0900, Jeff Moyer wrote:
>>>> >>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>>> >>>> On Thu, Jun 11 2009, Jeff Moyer wrote:
>>>>>> >>>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>>>> >>>>> Is blk_rq_unprep_clone really the best name?
>>>>>> >>>>>           ^^^^^^
>>>>> >>>> Probably not, but I'm not very good at coming up with elegant names.
>>>>> >>>> Your email should have included a new suggestion :-)
>>>> >>> Fair enough.  ;)
>>>> >>>
>>>>> >>>>  - blk_rq_unprep_clone(struct request *clone)
>>>>> >>>>      * Frees cloned bios from the clone request.
>>>> >>> Why not blk_rq_free_clone?
>>> >> Because the 'clone' is not freed in this interface.
>>> >> This interface frees only bios in the 'clone'.
>>> >> Allocating/freeing the 'clone' are the caller's work, since
>>> >> only the caller knows how to allocate/free it.
>>> >>
>>> >> 'prep' after 'alloc' and 'unprep' before 'free' is symmetric
>>> >> and I feel a good candidate for my request-stacking driver,
>>> >> so I chose it. 
>> > 
>> > I'm not a native English speaker as well, so I'm fine
>> > with blk_rq_{prep,unprep}_clone. But maybe the English
>> > people don't like it?
>> > 
>> > Perhaps
>> > blk_rq_{clone,declone} or blk_rq_{clone,declone}_bios
>> > 
>> > (Both unclone and declone are found on the net but are not
>> >  found in the free dictionary)
>
> I had a feeling that blk_rq_{clone,declone} allocates/frees
> the clone request inside the interfaces like bio_clone(), so
> I didn't take such namings.
> And, the clone setup interface may not only make bio clones
> but also do something else (for other request members), so
> I didn't add any 'bio' namings to the interfaces.
>
> Jens, what do you prefer?

I can live with it as it stands.  prep/unprep at least has some
symmetry.

Cheers,
Jeff
