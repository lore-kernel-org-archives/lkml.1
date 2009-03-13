Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZCMWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZCMWAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZCMWAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:00:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbZCMWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:00:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=GC1VJTk/Dvn48j0+7JrjHy5Bc+4mOjx7Chq2pvgHGLmUM2FW0lRvryLJv+Uc5Yof0
	VrY+YEakloQNhNgp/iAUA==
MIME-Version: 1.0
In-Reply-To: <20090313.140217.143696945.davem@davemloft.net>
References: <65634d660903131006n44f068dw18b2fe9dce25399e@mail.gmail.com>
	 <20090313.115137.254924980.davem@davemloft.net>
	 <65634d660903131358h765bef64y6a0f1b0db7400f6f@mail.gmail.com>
	 <20090313.140217.143696945.davem@davemloft.net>
Date: Fri, 13 Mar 2009 14:59:55 -0700
Message-ID: <65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com>
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to submit 
	to upper layer
From: Tom Herbert <therbert@google.com>
To: David Miller <davem@davemloft.net>
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If the hash is good is will distribute the load properly.
>
> If the NIC is sophisticated enough (Sun's Neptune chipset is)
> you can even group interrupt distribution by traffic type
> and even bind specific ports to interrupt groups.
>
> I really detest all of these software hacks that add overhead
> to solve problems the hardware can solve for us.
>

I appreciate this philosophy, but unfortunately I don't have the
luxury of working with a NIC that solves these problems.  The reality
may be that we're trying to squeeze performance out of crappy hardware
to scale on multi-core.  Left alone we couldn't get the stack to
scale, but with these "destable hacks" we've gotten 3X or so
improvement in packets per second across both our dumb 1G and 10G
NICs.  These gains have translated into tangible application
performance gains, so we'll probably continue to have interest in this
area of development at least for the foreseeable future.
