Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYGPEM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYGPEM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYGPEMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:12:48 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:29896 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750736AbYGPEMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:12:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xt/YoZBNN8Rkad6ROEiTVkpoMtcdTTzUU2gEuDdQHJbVAO5bSRwh/Lxpnnx8syUw3RZFFMpSTx+shB6/UPqQym6dtnP/L38RfhO/WnBHvs93PZR0NuOiM9maGZIFrrnX+l0O3BVQ5s4lTlwncCPE5hq3yK2C09enkqUFkGZ+rO0=  ;
X-YMail-OSG: lZQee68VM1nomA5ReD3V_6hBUo2BWmormiBZnMEbuUJCjhEvTzQs4SE42JIny0pKiRg_qCdZC9I4t6KUPMFl0Y4v2xzOjEBdrA.JIjeRVmqQmnoYxMszuxVhohVHqWK13sI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs bug in 2.6.26-rc9
Date: Wed, 16 Jul 2008 14:12:40 +1000
User-Agent: KMail/1.9.5
Cc: Dave Chinner <david@fromorbit.com>, Lachlan McIlroy <lachlan@sgi.com>,
       Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-mm@kvack.org
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <200807151617.58329.nickpiggin@yahoo.com.au> <20080715122250.GA15744@infradead.org>
In-Reply-To: <20080715122250.GA15744@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161412.40893.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008 22:22, Christoph Hellwig wrote:
> > It would be easily possible to do, yes.
>
> What happened to your plans to merge ->nopfn into ->fault?  Beeing
> able to restart page based faults would be a logical fallout from that.

Yeah I guess I should really do that, and you're right it would
work nicely for this.

Actually I have some code but it is not quite as nice as I'd like.
The problem is that we have the generic file fault handler, but not
a generic page mkwrite handler. So we still need some kind of
page_mkwrite aop which the file fault handler can then call if it
exists. It isn't a big problem AFAIKS, but just a bit irritating.
