Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZCOD6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZCOD6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZCOD6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:58:34 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:40412 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757208AbZCOD6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:58:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K2uNUJjobfH1SfDev7IfrznlEtiG/oJPDYsBxAqRNCumAzrs97GADNQxNzcj0JzU/PzKKniEkywcdXezDglmumhU8xtuPmKw+aEVAKmztGZVp8YwFlXmLXgsdreTyo2ZKxPW+Vlx0R635nHuL+MvKfPWpbV868zwhfqd4EDKvKE=  ;
X-YMail-OSG: lpZwQ1gVM1nOTAVBVIchsE_q4JJU7yu9MsWm1G1VfK1YbalnkF4EdlfN1HjkreHZ15RN775VM6I6aLsBGBnQCmNz4vkkNCf0LPeRq5NopE0u2DvzFTARKxeTcipjHA5PjM4iF2bdU9P7YJMqnRC_OgEFcqc9YRDpGC_.IKFiEZHpGk3VMiy0P_edyfoeDA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: sidc7 <siddhartha.chhabra@gmail.com>
Subject: Re: COW optimization on exec
Date: Sun, 15 Mar 2009 14:58:25 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <22519639.post@talk.nabble.com>
In-Reply-To: <22519639.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151458.25363.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 13:57:54 sidc7 wrote:
> The Linux kernel uses the COW optimization for fork, so the processes share
> the same pages, till on of the processes writes to the page. I was
> wondering, if I do a fork and do an exec immediately following the fork,
> will the COW optimization still be applied as it is most likely that the
> new process is going to write to the shared pages? So doing a COW will not

exec throws out all those pages, so go away without ever having been
copied. However it still costs memory CPU time TLB flushes etc in order
to set up the COW optimisation in the first place, so if you are doing
fork/exec, then I think vfork is the better option.


