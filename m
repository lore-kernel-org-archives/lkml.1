Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYKLWhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYKLWhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYKLWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:37:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:46751 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYKLWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ahIMvl3oug1SUXrmHCQj7bZlZwXm0iSHVFb67PIoiyv6bk3YY/42l3iPoHa1TzFYAh
         DfTfxiUbJQSNZYhvHbYsiOG3iaZWyno9kujool8YdkaHTSeAF6J0wTGyEe9iZIxw13tG
         GFbcUHaEJMmYhRe91wbWxTGPW3xHZKzti5PkU=
Message-ID: <b6c5339f0811121437v624737abka49b5aefd8f1def4@mail.gmail.com>
Date: Wed, 12 Nov 2008 17:37:00 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Mathieu Chouquet-Stringer" <mchouque@free.fr>,
       "Pavel Machek" <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Alex Deucher" <alexdeucher@gmail.com>,
       "Dave Airlie" <airlied@redhat.com>
In-Reply-To: <200811121357.02233.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081109195033.GA1335@mobydick> <20081112184236.GR26778@kernel.dk>
	 <200811122237.03882.rjw@sisk.pl>
	 <200811121357.02233.jbarnes@virtuousgeek.org>
X-Google-Sender-Auth: 4d6f5e3ce96fcd3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 4:57 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wednesday, November 12, 2008 1:37 pm Rafael J. Wysocki wrote:
>> On Wednesday, 12 of November 2008, Jens Axboe wrote:
>> > A drm enabled kernel also hangs hard on resume (just see the mouse
>> > pointer) here on the x60. Removing drm makes it work just fine. 2.6.27
>> > works fine as well.
>>
>> Is there Intel graphics in there?
>
> Yeah I think so... I wonder if this is another case where a POST conflicted
> with the kernel's restore and caused X to hang...
>
> Jens, does suspend/resume work if you just do it from the console (echo mem >
> /sys/power/state) with i915 loaded?

Here's a "me too" for resume troubles in 2.6.28, MacBook Core Duo with i915
graphics.  I'm about a week behind in my git tree though.

Probably unrelated, but in testing other stuff I noticed that 2.6.27.3 worked
whereas 2.6.27.4 does not.  Reverting "ACPI Suspend: Enable ACPI during resume
if SCI_EN is not set" makes it work there.  In 2.6.28-rc3, reverting the same
commit met with mixed success:

  * resuming from X got me one successful resume after a long timeout,
    and one resume with mouse-pointer-only
  * resuming from console always worked

With the above mentioned commit, resume never worked.

-- 
Bob Copeland %% www.bobcopeland.com
