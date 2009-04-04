Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZDDOXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZDDOXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 10:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZDDOWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 10:22:53 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:29158 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752972AbZDDOWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 10:22:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=V2l94Ixwq/NdhA0Wz9M+82L7GnEumq2UIlfxDv0u1U7GQRuqnsyAAr0ec2gXHbqc18Bzk0ArNXGZnJXs71IqbtM9aRG5c5PgTQv4p3E8SoFfU2KJYo6ClCXn0EFQbRU+F/1lKJjMrVBcwOBasA+yWLF9t7fvC0oCK0obuLJszPU=  ;
X-YMail-OSG: Ew7YsroVM1mUkmFDGfx8TPS0YZMXxaEdnIExVrdoHNYlo8BvU0wiMu2Fym3QBK3Dx_Fj6pprpmhsjpPZSInW.Rpl8jFH0QpJ_gB1DCO7UB2KyMDYMt21.soIaa.QQK_8rRrohWhY06pkcR2JCZIQ2cvLerHdy79zscERujWXVgzmDQ1IwE6eTBizz1TPdJjAGuLK6SNqgHemKzwFPSnL2q3SMgwcuql5ee5w0HxT0b02SI80EWbqavQtOKMcMhpIx6pLEm_Pj9Jul0.6VpSITVsEpEGC5dWvh8LYtFORxJfeIIOl5vcS
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 21/41] CacheFiles: Permit the page lock state to be monitored [ver #48]
Date: Sun, 5 Apr 2009 01:22:41 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk> <20090403155624.28714.87176.stgit@warthog.procyon.org.uk> <200904041709.31651.nickpiggin@yahoo.com.au>
In-Reply-To: <200904041709.31651.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904050122.42081.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 April 2009 17:09:31 Nick Piggin wrote:
> On Saturday 04 April 2009 02:56:24 David Howells wrote:
> > Add a function to install a monitor on the page lock waitqueue for a particular
> > page, thus allowing the page being unlocked to be detected.
> > 
> > This is used by CacheFiles to detect read completion on a page in the backing
> > filesystem so that it can then copy the data to the waiting netfs page.
> 
> This is the only thing I'm still worried about in core code. The extra
> page flag (which is probably unusable for any other fs, due to its
> semantics) is an issue, but Andrew seemed like he was willing to spend
> *2* page flags on this, so I'm sure he's happy with 1.

Well that is to say it is not a such a bad concept to have... actually
we already have exactly this concept which is what should be used. Ie.
the filesystem's io completion handler.
