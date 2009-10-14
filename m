Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbZJNAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbZJNAD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbZJNAD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:03:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:64252 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZJNAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:03:26 -0400
Message-ID: <4AD51519.8030902@windriver.com>
Date: Tue, 13 Oct 2009 19:02:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernhard Walle <bernhard@bwalle.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Always print panic message on current console
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>	<1255207870-24496-6-git-send-email-bernhard@bwalle.de>	<87d44sh5uj.fsf@basil.nowhere.org>	<4AD37478.2070204@bwalle.de> <20091012113055.13d3b7e3@jbarnes-g45> <4AD376B9.7040404@bwalle.de>
In-Reply-To: <4AD376B9.7040404@bwalle.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 00:02:34.0273 (UTC) FILETIME=[A1BFF110:01CA4C61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> Jesse Barnes schrieb:
>   
>> It's called in the panic notifier atm.  Yeah sounds like kexec vs
>> notifiers should be reordered a bit (or the current panic notifier
>> should be split into notify and "yes we actually failed to do anything"
>> cases).
>>     
>
> Well, we had that discussion several times. But maybe the opinion of
> some developers changed because now there would be an in-kernel user of
> notification before kexec.
>   

The other internal kernel user would be kdb (granted it is not merged to
the mainline at this point).  The prototype that we demonstrated at LPC
hooked the panic notification first and passed the string that was
passed to the panic.

Where KMS is integrated with KDB all the switching is dynamic and you do
get a chance to see what happened as well as interact with the
debugger.  The argument of folks who only care about kexec has always
been they want the first right of anything to get to kexec before
anything could get worse by going down any other code paths.

The kms does not have the choice to dynamically configure the behavior
on panic, where as kdb/kgdb is something you activate if you plan on
debugging (meaning user preference is clear).  Perhaps two notifiers is
the right answer.

Jason.
