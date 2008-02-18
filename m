Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYBRB6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYBRB6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYBRB6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:58:04 -0500
Received: from n31.bullet.mail.mud.yahoo.com ([68.142.201.26]:30841 "HELO
	n31.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751911AbYBRB6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:58:02 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 20:58:02 EST
X-Yahoo-Newman-Id: 830026.31835.bm@omp420.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AViaKke8Hoz3tGCO6NeTdtE+qeEklPrrELzkMwoudCZm9rzCh/US7SYt9WIv4hDtdD0hUabIznRAYTu77SH9cOU7g4rmFDNhiCxkhB1KQ7S81QrAkfoefd35cPXosAPKY1uQH9sHBbr7KWH3VE2fLZcFt73PcHJfTDzBVRAp1xM=  ;
X-YMail-OSG: _1.aSDwVM1khJA0suOptdWRlVPP5sh5eHKbqpy01MsNZBQnMHEw9ElXNDh7pfFFO8PkOCKrGsA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks
Date: Mon, 18 Feb 2008 12:51:27 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <20080215064932.918191502@sgi.com> <20080215193736.9d6e7da3.akpm@linux-foundation.org>
In-Reply-To: <20080215193736.9d6e7da3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181251.28813.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008 14:37, Andrew Morton wrote:
> On Thu, 14 Feb 2008 22:49:02 -0800 Christoph Lameter <clameter@sgi.com> 
wrote:
> > Two callbacks to remove individual pages as done in rmap code
> >
> > 	invalidate_page()
> >
> > Called from the inner loop of rmap walks to invalidate pages.
> >
> > 	age_page()
> >
> > Called for the determination of the page referenced status.
> >
> > If we do not care about page referenced status then an age_page callback
> > may be be omitted. PageLock and pte lock are held when either of the
> > functions is called.
>
> The age_page mystery shallows.

BTW. can this callback be called mmu_notifier_clear_flush_young? To
match the core VM.

