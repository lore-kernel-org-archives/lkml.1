Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYGNEvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYGNEvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYGNEvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:51:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:22491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYGNEvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QiytAwVu6gV3fOJxHrx7awHIcrzDaEJAnaK0wERgvgCswQKEFM2pRhOJlhdik5QMDw
         0jsqlURRzjE+KPZ9kzKfSd/62LyJZjUbZULTuJM0UDavX9GK7wwNz7yEw6USLtG/zV3L
         I+/6l/1w2fipGb+pduh8G6UmVAKg/UyhpCHCc=
Message-ID: <48f7fe350807132151udc3a462g688336a9fab7b768@mail.gmail.com>
Date: Mon, 14 Jul 2008 00:51:09 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: Performance Question: BUG_ON vs. WARN_ON_ONCE
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20080714073636.6c84be12@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com>
	 <20080714063657.6d1fda18@linux360.ro>
	 <48f7fe350807132110k4cd90e9j6907674ea7668f5b@mail.gmail.com>
	 <20080714073636.6c84be12@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon drm/dri is opensource, i use the radeonhd driver for xorg

On Mon, Jul 14, 2008 at 12:36 AM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> On Mon, 14 Jul 2008 00:10:50 -0400
> "Ryan Hope" <rmh3093@gmail.com> wrote:
>
>> well the bug I recieved looked like it had to do with highmem and this
>> was the only code relating to mem that got touched, as for the other
>> person, their crash was reproducible and it definitely was an oops,
>> numlock led started to blink and system was unresponsive, for both of
>> us
>> reverting this change seems fix the issue, my dmesg log is attached to
>> this message
>
> There are a few things you should take into account before anything else:
> 1. The bug does not occur there, but in other code.
> 2. The kernel is tainted.
> 3. The oopses start occuring just after you load that tainted module,
> or at least something related (that drm stuff is linked to the radeon
> module, I presume, which is proprietary AFAIK)
>
> So you should retest after eliminating all these possible noise and
> error sources. Test both if your fix (revert) is correct and if it
> crashes without your fix.
>
> My guess is that would've happened sooner or later and your fix just
> moved stuff around enough to mask it. That static int from WARN_ON_ONCE
> means another 4 or 8 bytes in the kernel image, which might set things
> off in an already unstable environment.
>
>
>        Eduard
>
