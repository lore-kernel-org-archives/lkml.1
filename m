Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYAXJHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYAXJHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYAXJG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:06:57 -0500
Received: from sacred.ru ([62.205.161.221]:34739 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYAXJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:06:55 -0500
Message-ID: <479854E7.5080404@openvz.org>
Date: Thu, 24 Jan 2008 12:05:43 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: righiandr@users.sourceforge.net
CC: Naveen Gupta <ngupta@google.com>, Jens Axboe <jens.axboe@oracle.com>,
       Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net> <20080120143239.GS6258@kernel.dk> <47936BC1.9060805@users.sourceforge.net> <20080120160651.GU6258@kernel.dk> <4793E047.1000602@users.sourceforge.net> <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com> <47967805.4060307@users.sourceforge.net> <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com> <47975C0F.3010609@users.sourceforge.net> <20080123153828.GB12333@balbir.in.ibm.com> <4797A9C3.1000707@users.sourceforge.net>
In-Reply-To: <4797A9C3.1000707@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 24 Jan 2008 12:05:33 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Balbir Singh wrote:
>> * Andrea Righi <righiandr@users.sourceforge.net> [2008-01-23 16:23:59]:
>>
>>> Probably tracking who dirtied the pages would be the best approach, but
>>> we want also to reduce the overhead of this tracking. So, we should find
>>> a smart way to track which cgroup dirtied the pages and then only when
>>> the i/o scheduler dispatches the write requests of those pages, account
>>> the i/o operations to the opportune cgroup. In this way throttling could
>>> be done probably in __set_page_dirty() as well.
>>>
>> I think the OpenVZ controller works that way.
> 
> Well... looking at the code it seems that OpenVZ doesn't use this
> strategy, instead performs UBC-based I/O accounting looking at the

We do track the task (well - the beancounter) who made the page
dirty and then use this context for async write scheduling.

> __set_page_dirty*() for writes and submit_bio() for reads. Then,
> independently from accounting data, it uses per-UBC i/o priority model
> that is mapped directly on the CFQ i/o priority model.

Vasisly Tarasov (out I/O guru ;)) has already prepared an RFC patchset
for Jens with group scheduler (for sync requests only) and is going to
send it this or next week.

> -Andrea
> 

