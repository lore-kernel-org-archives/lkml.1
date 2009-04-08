Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbZDHQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbZDHQNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbZDHQMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:12:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbZDHQMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:12:18 -0400
Message-ID: <49DCCCCB.9000201@zytor.com>
Date: Wed, 08 Apr 2009 09:11:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] do not keep interrupt window closed by sti in real mode
References: <1239161017-7398-1-git-send-email-glommer@redhat.com> <49DC24C2.7000608@zytor.com> <20090408145545.GA25323@poweredge.glommer>
In-Reply-To: <20090408145545.GA25323@poweredge.glommer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> 
> I get the idea from the pseudocode in sti description.
> It says:
> IF PE = 0 (* Executing in real-address mode *)
>     THEN
>         IF <- 1; (* Set Interrupt Flag *)
>     ELSE (* Executing in protected mode or virtual-8086 mode *)
> 
> There is no mention to any other activity besides setting the if flag.

But the same is true for the protected mode side of the instruction 
description!

> Also, sti is used extensively in many places like the linux kernel for the
> guest, and it works just fine in kvm. So I was led to believe that real mode
> in fact behaving differently.

The difference is that at least under current Intel VT, VT only handles 
protected mode -- the real mode runs purely in the interpreter.

> I'll take a look at avi's suggestion.

	-hpa
