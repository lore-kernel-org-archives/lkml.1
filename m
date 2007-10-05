Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbXJEPIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbXJEPIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXJEPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:07:55 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:6086 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbXJEPHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:07:54 -0400
From: Frans Pop <elendil@planet.nl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
Date: Fri, 5 Oct 2007 17:07:48 +0200
User-Agent: KMail/1.9.7
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Luca Tettamanti <kronos.it@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       Ingo Molnar <mingo@elte.hu>
References: <200710031433.34504.elendil@planet.nl> <200710042310.25223.borntraeger@de.ibm.com> <470562B9.6060200@redhat.com>
In-Reply-To: <470562B9.6060200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051707.49458.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2007 15:07:51.0761 (UTC) FILETIME=[7FCFDC10:01C80761]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007, Chuck Ebbert wrote:
> procfs: Don't read runtime twice when computing task's stime
>
> Current code reads p->se.sum_exec_runtime twice and goes through
> multiple type conversions to calculate stime. Read it once and
> skip some of the conversions.
>
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

This second patch is a major improvement. But both for kontact and amarok I 
still see stime decreasing occasionally. Sometimes even still quite 
frequently like in this series:

Oct 05 17:00:42 698 178
Oct 05 17:00:43 700 177
Oct 05 17:00:44 700 177
Oct 05 17:00:45 700 177
Oct 05 17:00:46 700 178
Oct 05 17:00:47 700 178
Oct 05 17:00:48 700 177
Oct 05 17:00:49 700 177
Oct 05 17:00:50 700 178
Oct 05 17:00:51 700 178
Oct 05 17:00:52 700 179
Oct 05 17:00:53 698 180
Oct 05 17:00:54 700 179
Oct 05 17:00:55 700 179
Oct 05 17:00:56 700 179
Oct 05 17:00:57 700 179
Oct 05 17:00:58 700 180
Oct 05 17:00:59 700 179

This was after 6 minutes of steady increases.
Should we try a debug patch that shows the raw data behind the calculations?

I'll give the first patch a try next.
