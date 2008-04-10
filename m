Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYDJIZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYDJIZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYDJIZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:25:47 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:27055 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYDJIZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:25:46 -0400
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] change clone_flags type to u64
From: Andi Kleen <andi@firstfloor.org>
References: <20080409222611.GA28087@us.ibm.com>
	<20080409223231.GA28267@us.ibm.com>
Date: Thu, 10 Apr 2008 10:25:44 +0200
In-Reply-To: <20080409223231.GA28267@us.ibm.com> (sukadev@us.ibm.com's message of "Wed, 9 Apr 2008 15:32:31 -0700")
Message-ID: <871w5enmk7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2008 08:19:00.0304 (UTC) FILETIME=[87959500:01C89AE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com writes:

> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Subject: [lxc-dev] [patch -lxc 1/3] change clone_flags type to u64
>
> This is a preliminary patch changing the clone_flags type to 64bits
> for all the routines called by do_fork(). 

I must admit I was always a little sceptical of giving every tiny
namespaceable kernel feature its own CLONE flag (and it's own 
CONFIG option). What was the rationale for that again?

With your current strategy are you sure that even 64bit will
be enough in the end? For me it rather looks like you'll
go through those quickly too as more and more of the kernel
is namespaced.

Also I think the user interface is very unfriendly. How
is a non kernel hacker supposed to make sense of these 
myriads of flags? You'll be creating another 
CreateProcess123_extra_args_extended() 
in the end I fear.

Wouldn't it be better to just partition all this into
fewer more understandable larger feature groups?  I think
that would be much nicer from pretty much all perspectives
(kernel maintenance, user interface sanity, not needing
clone128/256 in the end etc.) 

Some consolidation on the CONFIGs would be good too. I just
cannot imagine it really makes sense to configure everything
so fine grained and this is just asking for random compile
breakage on randconfig.

-Andi
