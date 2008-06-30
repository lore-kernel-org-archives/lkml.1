Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYF3VDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYF3VDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYF3VCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:02:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYF3VCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:02:52 -0400
Message-ID: <4869497B.5040100@redhat.com>
Date: Mon, 30 Jun 2008 18:00:43 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 17/39] clobber rbx in putuser_64.S
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>	<1214602486-17080-3-git-send-email-gcosta@redhat.com>	<1214602486-17080-4-git-send-email-gcosta@redhat.com>	<1214602486-17080-5-git-send-email-gcosta@redhat.com>	<1214602486-17080-6-git-send-email-gcosta@redhat.com>	<1214602486-17080-7-git-send-email-gcosta@redhat.com>	<1214602486-17080-8-git-send-email-gcosta@redhat.com>	<1214602486-17080-9-git-send-email-gcosta@redhat.com>	<1214602486-17080-10-git-send-email-gcosta@redhat.com>	<1214602486-17080-11-git-send-email-gcosta@redhat.com>	<1214602486-17080-12-git-send-email-gcosta@redhat.com>	<1214602486-17080-13-git-send-email-gcosta@redhat.com>	<1214602486-17080-14-git-send-email-gcosta@redhat.com>	<1214602486-17080-15-git-send-email-gcosta@redhat.com>	<1214602486-17080-16-git-send-email-gcosta@redhat.com>	<1214602486-17080-17-git-send-email-gcosta@redhat.com>	<1214602486-17080-18-git-send-email-gcosta@redhat.com> <87abh5pxl6.fsf@basil.nowhere.org>
In-Reply-To: <87abh5pxl6.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Glauber Costa <gcosta@redhat.com> writes:
> 
>> Instead of clobbering r8, clobber rbx, which is the i386 way.
> 
> Note rbx is callee saved on 64bit, so using that one means
> the surrounding function always has to save explicitely.
> Not the case with r8.
> 
> There's a reason it is the way it is.
> 
> -Andi
Right. Thanks for pointing this out.
However, r8 is not available for i386. We could use %ax, but it
holds part of the data for the call itself.

But for this case, I think we can come up with a macro that selects the 
appropriate register for each of them. Should be easy to do now that the 
code is merged.

Many thanks.
