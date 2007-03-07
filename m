Return-Path: <linux-kernel-owner+w=401wt.eu-S1422956AbXCGSDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422956AbXCGSDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422972AbXCGSDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:03:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXCGSDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:03:07 -0500
Date: Wed, 7 Mar 2007 10:02:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Neukum <oliver@neukum.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Oliver Neukum <oliver@neukum.name>,
       Maneesh Soni <maneesh@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <200703071759.29522.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0703071001020.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
 <d120d5000703070756v4fe11a54u9009d3efd93faa9d@mail.gmail.com>
 <Pine.LNX.4.64.0703070845500.5963@woody.linux-foundation.org>
 <200703071759.29522.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Oliver Neukum wrote:
>
> The problem also exists with unplugging devices. Drivers get no feedback
> to tell them when it is safe to free the data structures associated with
> an attribute.

So you just pointed to *another* data structure that apparently violates 
the "you MUST use refcounting" rule.

What is it with you people? It's really simple. Data structures must be 
refcounted if you can reach them two different ways.

If you don't use refcounting, then you'd better make sure that the data 
can be reached only one way (for example, by *not* exposing it for sysfs).

It really *is* that simple. Read the CodingStyle rules.

		Linus
