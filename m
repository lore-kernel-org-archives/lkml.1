Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbZEAPDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbZEAPDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762457AbZEAPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:03:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37513 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764810AbZEAPDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:03:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090501144857.GA25398@uranus.ravnborg.org>
References: <20090501144857.GA25398@uranus.ravnborg.org> <1241135661-9147-1-git-send-email-tabbott@mit.edu> <2425.1241188519@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 0/6] section name cleanup for mn10300
Date: Fri, 01 May 2009 16:03:25 +0100
Message-ID: <11976.1241190205@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> I also thing 5/6 is wrong as it moves
> init_task befoe _edata.
> 
> Could you try to back out them one by one
> to see which one causes the extra memory waste.

Moving init_task around is the culprit.

I guess the extra page has a 50% chance of being leaked anyway, as it depends
on the alignment of the previous section.

I can probably make the kernel reclaim it by sticking a label either side of
the alignment and if they're more than a page apart, reclaim the page that
ends at the second label.

David
