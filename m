Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab0AOUY1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247Ab0AOUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:24:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:55798 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab0AOUY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EAOKA2O/wamTLOprFPgbK4Jurlc2kODC0A61KP+FV+zLO4jv4BJOxBJ5G/zS4LXcCN
         y2kSyLnPh95uGcoUEg1hTiCfN7QhxTWJMIB9KhKBOMg04nlSGmvVuvRhp8vEgJJMpsKY
         Y3xwG/luAxqeA3kjLDIDDbpP950rGOHUgomcI=
MIME-Version: 1.0
In-Reply-To: <x494omnp2xd.fsf@segfault.boston.devel.redhat.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	 <20091228092844.GA9710@sli10-desk.sh.intel.com>
	 <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
	 <x49hbqy3s3m.fsf@segfault.boston.devel.redhat.com>
	 <1263187209.29897.33.camel@localhost>
	 <4e5e476b1001110705y6c3319ducf6a15c2a2be5670@mail.gmail.com>
	 <1263264218.29897.41.camel@localhost>
	 <4e5e476b1001151132l406054f6xcc47b94e817d3af0@mail.gmail.com>
	 <x494omnp2xd.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 15 Jan 2010 21:24:23 +0100
Message-ID: <4e5e476b1001151224x5c94382cnf2a6696f10c9800d@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as 
	close
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 8:45 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Hi Jeff,
>> I think this patch has the same flaw as Shaohua's.
>> The seekiness check that you introduce in cfq_rq_close is already
>> present in its caller, cfq_close_cooperator, so it is not effective.
>
> I don't think so.  There are two queues, here.  One queue is checked by
> the caller, and that is the cur_cfqq.  The __cfqq needs to also be
> checked.
The other one, i.e. the returned one, is also checked by the caller,
some lines below.
1756         cfqq = cfqq_close(cfqd, cur_cfqq);
1757         if (!cfqq)
1758                 return NULL;
1759
1760         /* If new queue belongs to different cfq_group, don't choose it */
1761         if (cur_cfqq->cfqg != cfqq->cfqg)
1762                 return NULL;
1763
1764         /*
1765          * It only makes sense to merge sync queues.
1766          */
1767         if (!cfq_cfqq_sync(cfqq))
1768                 return NULL;
1769         if (CFQQ_SEEKY(cfqq))
1770                 return NULL;
>
>> Up to now, the only patch that improves this situation is the one that
>> changes the unmerge policy to unmerge after a single time slice.
>
> Yes, I definitely agree with that, and I think that patch should go in.
>
> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
