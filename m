Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbXLDCKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbXLDCKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 21:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXLDCJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 21:09:56 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:25201 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750709AbXLDCJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 21:09:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Konr8JsTPtYME7550yE2JygFiwoPsm6YMBW4J2cv1+dLRQ6uf9mGLesZKWIZyhWBSvSJW5GzsWDZla2KIxwhw/6PSWfmsYrI9LbY496E57ehUN2XLeEbgY3RnoFqDlzvMZ6vpGID/ALgrxeTppi4OcDAIJyXJ/QHNiiRZi6JrBo=  ;
X-YMail-OSG: O3u3IWsVM1ksFYmxaJGVzlRAte28K08rm4_3Yo5XQH5Ro9kpKAcJn4B.xzGFBr9lAOpmO9QV7w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: davids@webmaster.com
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Tue, 4 Dec 2007 13:09:48 +1100
User-Agent: KMail/1.9.5
Cc: "Mark Lord" <lkml@rtr.ca>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Friesen" <cfriesen@nortel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKKEINIJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEINIJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041309.48451.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2007 11:30, David Schwartz wrote:

> Perhaps it might be possible to scan for the task at the same static
> priority level that is ready-to-run but last in line among other
> ready-to-run tasks and put it after that task?

Nice level versus posix static priority level debate aside, this
is the exact behaviour which the compat mode does now basically,
when you have all tasks running at nice 0 (which I assume is the
essentially the case in both the jvm and firefox tests) (some
things, eg. kernel threads or X server could run at a higher prio,
but these are not the ones calling yield anyway...)


> I think that's about as 
> close as we can get to the POSIX-specified behavior.

I don't think it is a question of POSIX being a bit fuzzy, or some
problem we have implementing it. It is explicitly specified to
allow any behaviour.

So the current default is not wrong, any more than the compat mode
is right.
