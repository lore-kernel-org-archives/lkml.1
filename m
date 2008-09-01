Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYIANhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYIANhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYIANg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:36:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:24645 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYIANg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HhkG0Ce6rBYPiRL5BwlW3cmTR5naU0uh00zLA8IZUFo0B/vx0Kgoj/ElyW7GhnKpy3
         nxJl7k1aZPxpoHzSnESaCYAPK19hUTHAfSV9NhlBr7pmUeagI3RJ1IU2jcclZL/1unUZ
         yJyqy5NuM+WfPDXqw7FwpjbHMZCfHUwE0bqTo=
Message-ID: <87a5b0800809010636m227bce15y59d8bb988a601802@mail.gmail.com>
Date: Mon, 1 Sep 2008 14:36:56 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       alex.williamson@hp.com
In-Reply-To: <20080826105845.6ddf1107.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808261045.34699.david-b@pacbell.net>
	 <20080826105845.6ddf1107.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 6:58 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 26 Aug 2008 10:45:34 -0700
> David Brownell <david-b@pacbell.net> wrote:
>
>> > > Also, how serious is the problem which is being fixed here?  It
>> > > _sounds_ like it's of the "fatal for people who have that hardware"
>> > > variety, in which case we should get this into 2.6.27 and probably
>> > > 2.6.26.x.  Not sure about 2.5.26.x though - the patch doesn't apply
>> > > there, but I didn't check whether this is due to functional changes.
>> >
>> > For users of this version of this particular UART IP it is fatal. From
>> > looking at the git history it looks like the original patch went into
>> > 2.6.26 so it might also affect that kernel.
>>
>> Second that:  serial-8250-tighten-test-for-using-backup-timer.patch
>> (from MMOTM) in mainline sooner-not-later seems right.
>
> ok, if you think so...
>
> I still have an unanswered question out there about the init_timer()
> handling in that area of the driver but afaict this patch didn't make any
> of it worse than it already is.

Any update on this situation? I'd really like this patch to get into 2.6.27.

Let me know if there's any further information you need.

Thanks,

>> My own exposure to this is that the UART on DaVinci hardware, which
>> TI allegedly derived from its original 16550 logic, has periodically
>> gone from working to unusable with the mainline 8250.c ... and back
>> and forth a bunch.  Currently it's "unusable", a regression from some
>> previous versions.  With this patch from Alex, it's usable.
>>
>> Of course there are a bunch of arch/arm/mach-davinci patches needed
>> to make that platform more functional in mainline.  I expect they'll
>> probably merge in the 2.6.28-rc0 window.  Meanwhile, running out of
>> ramdisk with a serial console should at least work right!  :)
>>
>
>
