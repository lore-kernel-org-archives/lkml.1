Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbZGZJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbZGZJcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 05:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZGZJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 05:32:14 -0400
Received: from mail-pz0-f172.google.com ([209.85.222.172]:35209 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZGZJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 05:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y0KogivSj40Zh56GR58AhZqJgHDhI0GamiiStHsyaffzgPn2HmJUlMxMMb+S71LiIp
         l09SH1cQLSzjxYtDQ8pvGfT4xuc61OMwYJVf2SFGy+s6CWUT7un+sZAKkPGjTK4xT2n3
         Xkzcg5l175VLHZIWccdX/yl/NSMTs+LHJqig8=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a50907250636h17be6678u75b5e5a68522ada4@mail.gmail.com>
References: <1248419547-30261-1-git-send-email-dfeng@redhat.com>
	 <d82e647a0907242038l460c01b0ud51a7265f70d6c2e@mail.gmail.com>
	 <7b6bb4a50907242334m15335df6xaa0a8f96fc6cfcd4@mail.gmail.com>
	 <d82e647a0907242352i5e184dd2i488ae6918e9cd959@mail.gmail.com>
	 <7b6bb4a50907250636h17be6678u75b5e5a68522ada4@mail.gmail.com>
Date: Sun, 26 Jul 2009 17:32:13 +0800
Message-ID: <d82e647a0907260232i148c2a3fhb69d61faad01b6e7@mail.gmail.com>
Subject: Re: [PATCH] lib/kobject: put kobject if kobject_add_internal fails
From: Ming Lei <tom.leiming@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/25 Xiaotian Feng <xtfeng@gmail.com>:
>
>
> On Sat, Jul 25, 2009 at 2:52 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> Even you can make sure _all_ .release of the passed kobj_type does not
>> free
>> the kobject, you still have the double calling of kobject_put problem,
>> don't you?
>
>
> hmm, how about change kobject_put to kfree(kobj->name) ? Then it's safe for
> both cases, right?

No, it is very buggy and ugly to kfree kobj->name directly by kobject
users instead
of kobject_put().  Image that someone uses the kobject after kfree(kobj->name)
but before kobject_put,  oops may happen.

Why don't you fix the 20+ callers of  kobject_init_and_add?  It is the
standard way of doing
such thing.

-- 
Lei Ming
