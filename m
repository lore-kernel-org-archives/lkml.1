Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbZFQNBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbZFQNBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZFQNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:00:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49491 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZFQNAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:00:48 -0400
Date: Wed, 17 Jun 2009 08:59:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 02/19] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090617125932.GA15473@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-3-git-send-email-vgoyal@redhat.com> <af41c7c40906161244q61fd47c5u1a10243c8839938@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af41c7c40906161244q61fd47c5u1a10243c8839938@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:44:58PM -0700, Divyesh Shah wrote:
> On Mon, Jun 8, 2009 at 7:08 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> > void elv_deactivate_ioq(struct elv_fq_data *efqd, struct io_queue *ioq,
> > +                                       int requeue)
> > +{
> > +       if (ioq == efqd->active_queue)
> > +               elv_reset_active_ioq(efqd);
> > +
> > +       bfq_deactivate_entity(&ioq->entity, requeue);
> > +}
> 
> The check for ioq == efqd->active_queue and the call to
> elv_reset_active_ioq() seem to be unnecessary. This gets called from
> elv_del_ioq_busy() which has 2 callers which:
> - either explicitly check for ioq != efqd->active_queue
> - or call elv_reset_active_ioq() right before invoking this function
> 
> This was needed earlier as the io_ioq_move() function didn't fall in
> one of the 2 categories above. This has been done away with the ref
> counting patch, AFAICT.

True. Looks like we don't need above reset_active_ioq() call in
deactivate_ioq(). I will get rid of it in next posting. Thanks.

Vivek
