Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYJ3Q1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYJ3Q1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYJ3Q1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:27:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:65361 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYJ3Q1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eHzm5cQJot3+FNHQy8YPmiBHVQCY8CK8M91NE1qh2thbpNQPTAdwbGpsTVs5l5lW6f
         o752nm/BDX0Vtrg4tXjDWLFumcN7zP6n1DGe1TVmciG5Cev0Ypeiad6uyGMOWD0hDitK
         8JKhiMVzX60xDCUmk3Ujqiptm+tOaRxPW/PeA=
Message-ID: <7a6abd110810300927l428b11f3u509ad31364c08f1f@mail.gmail.com>
Date: Thu, 30 Oct 2008 17:27:30 +0100
From: "Jonas Bonn" <jonas.bonn@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] API for system clocks (oscillators)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
	 <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> How does this compare to the framework in linux/include/linux/clk.h?
>

clk.h is pretty much just an infrastructure for "storing" clock data
and accessors... it does not provide:

i) Constraints on selectable frequencies of active devices
ii) Notifiers on frequency change, including changes due to events
such as reparenting

These are the big ones that cause headaches.  When I want to switch
frequency, I have to check elsewhere which devices are active and
which frequencies they allow.  When a frequency changes, I have to
manually make sure that the active devices are notified properly of
the change.  These are the main things that my document tries to
consolidate into one framework.  Like I said, I'm not sure it's the
right approach, that's why I requested feedback...

/Jonas
