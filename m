Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbYJIK2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbYJIK2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYJIK2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:28:03 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:41859 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753779AbYJIK2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:28:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P3PO7glRn/G18QGmXM734NGDmLV8VWK+9j+gHINd3Y7jFcVQKpF8fNEBaFuFo65P19iPgMv3KbHgHbtaxmBX6hzlsuVp28NrPiTLlf8GPqxYfnT3ZMr5DlYzrKnGZwF0/BvDHnVzIRRZDy2zP85xJJ6rGWLYXwfDhdHtvxRTRSU=  ;
X-YMail-OSG: ztApi3UVM1mUHBCpv6Nd2FbmB3.1W0PYG09TeZ95mCH.f06pcwRVDYQLi3SI8hl62aRD1VSb3VIxR17QNx61q_uACx0z9Gi0XhntMCD.piwvsPRB_VNgb3gyrMIa2td5Oj4vWyPKUxfvlmZ7CP6HkRAGiGR0DFOmBpL86pGp
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] documentation: explain memory barriers
Date: Fri, 10 Oct 2008 08:27:50 +1100
User-Agent: KMail/1.9.5
Cc: Chris Snook <csnook@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
References: <20080911101616.GA24064@agk.fab.redhat.com> <48ED9BFB.4060904@redhat.com> <1223546298.3984.100.camel@achroite>
In-Reply-To: <1223546298.3984.100.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100827.51024.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008 20:58, Ben Hutchings wrote:
> On Thu, 2008-10-09 at 01:51 -0400, Chris Snook wrote:

> > I'm completely in favor of documenting everything that can potentially
> > interact with that train wreck, but I maintain that the vast majority of
> > memory barriers are self-evident.
>
> Acquire and release barriers attached to operations are usually self-
> evident; standalone wmb() and rmb() much less so.  It is helpful to be
> explicit about exactly which memory operations need to be ordered, which
> are often not the memory operations immediately preceding and following
> it.  "all" may have been a bit strong though.

No, I don't think so. We should absolutely force "all". That allows nobody
to be lazy, no confusion, and reminds people that memory barriers are not
easy to follow for a new reader of the code, or necessarily even the author,
6 months later. If somebody is too lazy to write a comment, they can use
locks

One last quick quiz, easier than the earlier ones...
mm/vmscan.c:__remove_mapping has a score of lines documenting exactly
what memory operations are being ordered, and even an example of what
happens if the ordering is not folllowed. This is a pretty good comment,
if I say so myself. However, it has one deficiency in that it doesn't
explicitly state where the write barrier(s) is (IMO the comments for one
part of an ordering protocol should reference the other parts of the
protcol).

Where are the store barriers, or why are they not required?
