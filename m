Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbZD3Jah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbZD3Jah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZD3JaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:30:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:48363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZD3JaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:30:22 -0400
Message-ID: <49F96E96.5040107@kernel.org>
Date: Thu, 30 Apr 2009 18:25:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/10] block: add rq->resid_len
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-4-git-send-email-tj@kernel.org> <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com> <49F905EE.2020407@kernel.org> <20090430064549.GC6725@liondog.tnic> <49F95101.3010004@kernel.org> <20090430073719.GA9640@liondog.tnic>
In-Reply-To: <20090430073719.GA9640@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 09:25:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>> And I like it too, we've been coming up with all sorts of hacks in
>>> ide-atapi wrt to residual completion and accounting of what got xferred
>>> already and rq->resid_len is much more cleaner, IMHO.
>>>
>>> /me testing...
>> AFAICT, residual count handling in ide was most broken.

Oooh... It was "mostly broken" not "most broken".  Where went my l and
y?

> Tell me about it :).
> 
>> This patch doesn't fix anything other than making it report 0
>> resid_len on SG_IO which is usually better than reporting full
>> residual count. The only place inside ide where residual count is used
>> in the tape driver to determine actually transferred size. That part
>> works okay with the patch applied.
> 
>> Hmmm... maybe it's about time to finally clean up residual count
>> handling in ide and libata, which BTW doesn't do anything about it at
>> the moment.
> 
> Completely agreed. This doesn't do anything about it right now but
> with rq->resid_len in place I could get rid of a bunch of pc->xferred,
> cmd->nleft and similar on-stack structs we've been introducing, and use
> solely an rq in the LLD. I'll get to do some experimenting tomorrow and
> whip up some cleanup patches in order to see how it could look exactly.
> Stay tuned.

Yay, cool.  :-)

-- 
tejun
