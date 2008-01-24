Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbYAYIqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbYAYIqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbYAYI06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:26:58 -0500
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:33797 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbYAYI0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:26:54 -0500
Date: Thu, 24 Jan 2008 19:20:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Pavel Emelyanov <xemul@openvz.org>, Naveen Gupta <ngupta@google.com>,
       Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Message-ID: <20080124135020.GB4162@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrea Righi <righiandr@users.sourceforge.net>,
	Pavel Emelyanov <xemul@openvz.org>,
	Naveen Gupta <ngupta@google.com>,
	Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080120160651.GU6258@kernel.dk> <4793E047.1000602@users.sourceforge.net> <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com> <47967805.4060307@users.sourceforge.net> <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com> <47975C0F.3010609@users.sourceforge.net> <20080123153828.GB12333@balbir.in.ibm.com> <4797A9C3.1000707@users.sourceforge.net> <479854E7.5080404@openvz.org> <47989711.3070708@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <47989711.3070708@users.sourceforge.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righiandr@users.sourceforge.net> [2008-01-24 14:48:01]:

> Pavel Emelyanov wrote:
> > Andrea Righi wrote:
> >> Balbir Singh wrote:
> >>> * Andrea Righi <righiandr@users.sourceforge.net> [2008-01-23 16:23:59]:
> >>>
> >>>> Probably tracking who dirtied the pages would be the best approach, but
> >>>> we want also to reduce the overhead of this tracking. So, we should find
> >>>> a smart way to track which cgroup dirtied the pages and then only when
> >>>> the i/o scheduler dispatches the write requests of those pages, account
> >>>> the i/o operations to the opportune cgroup. In this way throttling could
> >>>> be done probably in __set_page_dirty() as well.
> >>>>
> >>> I think the OpenVZ controller works that way.
> >> Well... looking at the code it seems that OpenVZ doesn't use this
> >> strategy, instead performs UBC-based I/O accounting looking at the
> > 
> > We do track the task (well - the beancounter) who made the page
> > dirty and then use this context for async write scheduling.
> 
> Interesting... now I see that task_io_account_write() takes a
> "struct page *" as argument and the "struct page" has the beancounter
> pointer.
> 
> > 
> >> __set_page_dirty*() for writes and submit_bio() for reads. Then,
> >> independently from accounting data, it uses per-UBC i/o priority model
> >> that is mapped directly on the CFQ i/o priority model.
> > 
> > Vasisly Tarasov (out I/O guru ;)) has already prepared an RFC patchset
> > for Jens with group scheduler (for sync requests only) and is going to
> > send it this or next week.
> > 
> 
> Very good! I look forward for this patchset.
>

Excellent! Can't wait to test it.
 
> Thanks,
> -Andrea

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
