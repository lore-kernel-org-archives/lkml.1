Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZLVLdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZLVLdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZLVLdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:33:43 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62047 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZLVLdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:33:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hy7nsrIYc+TBlfbiHgPglfsI6ltE9nM2A2ewXYmW5pFs/En0YiIAy0QeYorKcO5Ply
         +pY2t7ECnQ24l/fuHdZxxr9+8Vu6DlZMrdgTDqJHX5RrFXvqq5R1l8613gc1XaS4mTFl
         fJKSNv200z7I7CYbq4jvLiOohxE4uzPEbhUeE=
Message-ID: <4B30AE8E.8060805@gnu.org>
Date: Tue, 22 Dec 2009 12:33:34 +0100
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: David Daney <ddaney@caviumnetworks.com>,
       Jamie Lokier <jamie@shareable.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> 	 <20091217150120.GD24967@shareable.org> 	 <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com>
In-Reply-To: <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 06:17 PM, Richard Guenther wrote:
> It shouldn't as *(int *)0 = 0; might trap.  But if you want to be sure
> use
>     __builtin_trap ();
> instead for the whole sequence (the unreachable is implied then).
> GCC choses a size-optimal trap representation for your target then.

Agree that it shouldn't but just to be sure I'd use

   *(volatile int *)0 = 0;
   unreachable ();

Paolo
