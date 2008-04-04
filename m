Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYDDXJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYDDXJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYDDXJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:09:44 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:40245 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752575AbYDDXJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:09:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mFpiZvgqTYQ6gRiooGViMTjhqdAjaJuExix4Uu/70HxsYqN6suGWus1PCUD/irc8aPnUh3GLcvVO1s4ptuT/TPbUj81P/k079RHblQ02+S5CQa3XO2lyrHxJILKqmRWxJLdqY80+5vxSoSijOdv5VhkhfUVMG5p+XyDqkjMbwjw=  ;
X-YMail-OSG: fazvV_kVM1kIVaYEiUetTv4ph.qZqP9JZAvBkh2l8Y3CCaKdMOkBZlqNcPd0y3IG3zCIKGeF0Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH]  jffs2 summary allocation
Date: Fri, 4 Apr 2008 16:09:40 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michael Trimarchi <trimarchimichael@yahoo.it>, dwmw2@infradead.org,
       spi-devel-general@lists.sourceforge.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com> <20080404124812.d39fa640.akpm@linux-foundation.org>
In-Reply-To: <20080404124812.d39fa640.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041609.41092.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Andrew Morton wrote:

> I'm assuming from the trace that the arm code tried to put that memory
> under DMA (or at least, passed it into part of the DMA management code to
> get the various caches sorted out) and that the arm DMA support code
> doesn't like being given vmalloced memory.

Actually, Documentation/DMA-Mapping.txt has a section right up
front called "What memory is DMA'able?" ... which despite its
ungrammatical title, says clearly:

  ... This means specifically that you may _not_ use the
  memory/addresses returned from vmalloc() for DMA.  ...

So I'm rather surprised to see *ANY* kernel code trying to do
that.  That rule has been in effect for many, many years now.

- Dave
