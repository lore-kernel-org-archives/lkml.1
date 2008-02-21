Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbYBUUul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbYBUUul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYBUUti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:49:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765314AbYBUUt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:49:29 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, dmitry.torokhov@gmail.com,
       virtualization@lists.osdl.org, linux-input@vger.kernel.org,
       adaplas@pol.net, akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: Re: [PATCH 0/2] xen pvfb: Para-virtual framebuffer,	keyboard and pointer
References: <871w76ejdg.fsf@pike.pond.sub.org>
	<87hcg2cyti.fsf@pike.pond.sub.org> <47BDD4BF.3000808@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 21 Feb 2008 21:47:09 +0100
In-Reply-To: <47BDD4BF.3000808@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 21 Feb 2008 11\:45\:03 -0800")
Message-ID: <871w76ca0i.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Markus Armbruster wrote:
>> Forgot to mention: This patch depends on
>>
>>     Subject: [PATCH] xen: Make xen-blkfront write its protocol ABI to xenstore
>>     From: Markus Armbruster <>
>>     Date: Thu, 06 Dec 2007 14:45:53 +0100
>>
>> http://lkml.org/lkml/2007/12/6/132
>>
>> Sorry!
>
> Sorry, I haven't pushed this upstream yet, since there didn't seem to
> be any particular urgency.  What's the dependency?
>
>    J

Here's the description again:

    Frontends are expected to write their protocol ABI to xenstore.  Since
    the protocol ABI defaults to the backend's native ABI, things work
    fine without that as long as the frontend's native ABI is identical to
    the backend's native ABI.  This is not the case for xen-blkfront
    running 32-on-64, because its ABI differs between 32 and 64 bit, and
    thus needs this fix.

I can break the dependency by putting the same bug that is now in
xen-blkfront into xen-fbfront and xen-kbdfront.
