Return-Path: <linux-kernel-owner+w=401wt.eu-S935767AbYCSU7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935767AbYCSU7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbYCSTtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:49:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759458AbYCSTtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:49:31 -0400
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	<87k5kt6vd3.fsf@pike.pond.sub.org>
	<45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
	<871w6z6ajs.fsf@pike.pond.sub.org>
	<45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 19 Mar 2008 11:45:29 +0100
In-Reply-To: <45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com> (Jaya Kumar's message of "Tue\, 26 Feb 2008 10\:01\:16 -0500")
Message-ID: <87iqzjat6e.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Tue, Feb 26, 2008 at 9:45 AM, Markus Armbruster <armbru@redhat.com> wrote:
>>
>>  What about pushing the fb_defio fixes independently of any new
>>  fb_defio users?  If fb_defio was worth merging into Linus's tree, it
>>  should be worth fixing there, whether new users are in shape already
>>  or not.
>
> I think that Andrew's message is saying that there may be a race
> condition in the defio patch itself as opposed to the defio user
> patch.
>
> If there is no race condition or other problems, then I think it would
> make sense to merge the defio patch independent of metronomefb or
> other new patches that use defio.
>
> Thanks,
> jaya

Any progress on this?

Considering that fb_defio is utterly broken without the fix (writing
the frame buffer makes the VM endlessly invoke vm_ops.page_mkwrite()),
wouldn't it make sense to merge the fix even if it still has issues?
