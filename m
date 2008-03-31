Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYCaI1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYCaI1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYCaI1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:27:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbYCaI1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:27:23 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: xen: Make hvc0 the preferred console in domU
References: <87zltm1p0s.fsf@pike.pond.sub.org> <47F08688.6050206@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 31 Mar 2008 10:27:07 +0200
In-Reply-To: <47F08688.6050206@goop.org> (Jeremy Fitzhardinge's message of "Sun\, 30 Mar 2008 23\:36\:56 -0700")
Message-ID: <87fxu79u3o.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Markus Armbruster wrote:
>> This makes the Xen console just work.  Before, you had to ask for it
>> on the kernel command line with console=hvc0
>>   
>
> I see that this has been causing issues when people expect the pvfb
> driver to be the console.  Should we make it a config option, which
> depends on !XENFB?
>
>    J

That's not quite right, I fear: you still lose if you have it compiled
into the guest, but switched off in your domain configuration.

I'm working on a better solution.
