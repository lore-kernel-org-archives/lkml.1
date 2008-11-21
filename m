Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYKUQEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYKUQEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYKUQEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:04:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:41626 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYKUQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:04:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xN6mzI+0o8h37LwHuI7/7Ujs1Xx2Zi8pu6+TT7yrrICRG55MIUXbwBC1k7UN61chrq
         faeJcOeRoaviBYWKVw4ujZ2KzrHhTTl0Qjxb8NMOPgFvXKf/qVHHB23VWUtQ6e813QQA
         g0nUfHedy+kfSRGLbuBRtdz/12/ouRDrPfBYk=
Date: Fri, 21 Nov 2008 11:04:36 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
Message-ID: <20081121110128.ZZRA012@mailhub.coreip.homeip.net>
References: <49142351.9080805@euromail.se> <20081119113508.ZZRA012@mailhub.coreip.homeip.net> <4926C95C.7000609@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926C95C.7000609@bitmath.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Nov 21, 2008 at 03:44:44PM +0100, Henrik Rydberg wrote:
> Dmitry,
> 
> My patch is all wrong. It would certainly benefit from using the
> EV_SYN/SYN_MT_REPORT, but the defuzz mechanism of the EV_ABS class
> simply will not work when sending data for several different fingers
> using the same event.
> 
> I can see two clear alternatives: either add a new event class, EV_MT,
> which sends all data without trying to limit the bandwidth, or forget
> about the whole serial-finger-data idea and expand the current EV_ABS
> class with an array of MT finger data [1]. I would very much appreciate
> your input on this. Maybe there is a third option.
> 

I don't like the idea of a new class since the finger data is a part
of absolute device state (in my opinion anyway). I am not sure if we
really need to pre-allocate space for 10 fingers either. Could we just
mark certain EV_ABS events as uncacheable in the input core? It could
be implemented with one static bitmap.

-- 
Dmitry
