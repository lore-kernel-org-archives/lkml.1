Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbZJMWVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbZJMWVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZJMWVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:21:31 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41564 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755235AbZJMWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:21:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=gzjsjZI92PP8l6pusp/bRuoMEMiwedMKti3NZ73TX0fx7riptZDjBBeFYaATIEalYVqnS3gg4XKKfsjKl2Ga70S8SiaHBEH/XoBthDf2kvmDTjpaFrSB9g83Se3HF/fNGpB8KGTqcgUhacQJZ9k3cWvnLFjA7CgmJR9WFvSJPh4=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: WaE9s70VM1kAwodAZf.0wvfo_Tl8nDP56.RdqQna4O5uU5fHm4dpvQA4F_.iPVn6_6D6Nw82Q9W_y7CcXAqNg4agraQkrooZEG0aT9ylzSDDbQMvGLjKqDiNMJadO3NQPwIiMaLhtgsHCucYi1nZ.5NJgImvA6baqzGGAGL_WWMdZUAxSzVWOFxd6_0MlogyXzq_6dtpRGdfMgXuFxVR5Ym4NhUoVL2Ww3Vjl0BSJEz_mSdcB9M3zXJH5Q_ot9fIq8L2zU5EGvPnOM201fLM6Y8UpiJ6tBaiktP7
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Date: Tue, 13 Oct 2009 15:13:53 -0700
User-Agent: KMail/1.9.10
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, dsilvers@simtec.co.uk
References: <20091010134814.0bac8624@bike.lwn.net> <20091012092331.45d7e71b@bike.lwn.net> <1255422669.5347.281.camel@ben-desktop>
In-Reply-To: <1255422669.5347.281.camel@ben-desktop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910131513.53851.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Ben Nizette wrote:
> If gpios are going to be named, and it seems they are,

I'm not so sure of that.  Keep in mind that "name" implies, to me,
focussing on name-centric operation, with lookup and browsing.
Neither of those mechanisms is fundamental to what GPIOs solve.

So far I've not seen any use case that can't be addressed within
the current framework, which keys only on numeric IDs.  If we *did*
see such cases appear in real-world scenarios, we could explore
what that means.


> then personally 
> I'd like to see the names field of struct gpio_chip go and a proper
> namespace layer inserted.  Something which allows gpio_name() and
> gpio_lookup() and decentralises that responsibility would be nice (the
> chip could call gpio_name itself if it has reason).  That code could be
> common to all gpio framework implementations.

But why would we need such lookups in the first place?

In-kernel, they are not needed, for either static or dynamic ID
assignment schemes.  Just register the numbers so they're available
as needed.

For userspace, I think gpio_export_link() is the best way to
go ... it scopes the names sanely, so there's no requirement
for driver-provided labels to be globally unique.

- Dave

