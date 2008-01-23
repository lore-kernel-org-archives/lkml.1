Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYAWUz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYAWUz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYAWUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 15:55:49 -0500
Received: from as4.cineca.com ([130.186.84.251]:60120 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYAWUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 15:55:48 -0500
Message-ID: <4797A9C3.1000707@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrea Righi <righiandr@users.sourceforge.net>,
       Naveen Gupta <ngupta@google.com>, Jens Axboe <jens.axboe@oracle.com>,
       Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net> <20080120143239.GS6258@kernel.dk> <47936BC1.9060805@users.sourceforge.net> <20080120160651.GU6258@kernel.dk> <4793E047.1000602@users.sourceforge.net> <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com> <47967805.4060307@users.sourceforge.net> <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com> <47975C0F.3010609@users.sourceforge.net> <20080123153828.GB12333@balbir.in.ibm.com>
In-Reply-To: <20080123153828.GB12333@balbir.in.ibm.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 21:55:32 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Andrea Righi <righiandr@users.sourceforge.net> [2008-01-23 16:23:59]:
> 
>> Probably tracking who dirtied the pages would be the best approach, but
>> we want also to reduce the overhead of this tracking. So, we should find
>> a smart way to track which cgroup dirtied the pages and then only when
>> the i/o scheduler dispatches the write requests of those pages, account
>> the i/o operations to the opportune cgroup. In this way throttling could
>> be done probably in __set_page_dirty() as well.
>>
> 
> I think the OpenVZ controller works that way.

Well... looking at the code it seems that OpenVZ doesn't use this
strategy, instead performs UBC-based I/O accounting looking at the
__set_page_dirty*() for writes and submit_bio() for reads. Then,
independently from accounting data, it uses per-UBC i/o priority model
that is mapped directly on the CFQ i/o priority model.

-Andrea
