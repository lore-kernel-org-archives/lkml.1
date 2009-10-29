Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZJ2CW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZJ2CW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZJ2CW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:22:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbZJ2CW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:22:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CC2amjYn/UUoHXTXD+WvPVzCgSnUqYjB/aS8b9dxBsK9N818EWHKP+DhWy/xArtq6
	/uqJNiaBJQ47lVhGhNfEg==
MIME-Version: 1.0
In-Reply-To: <4AE8F604.2090005@canonical.com>
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
	 <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
	 <20091027140558.GA17208@suse.de> <4AE8E953.6090504@canonical.com>
	 <20091029010419.GA18410@suse.de> <4AE8EBCB.5030102@canonical.com>
	 <20091029011759.GA908@suse.de> <4AE8EF8C.9030805@canonical.com>
	 <20091029012857.GA30274@suse.de> <4AE8F604.2090005@canonical.com>
Date: Wed, 28 Oct 2009 19:22:28 -0700
Message-ID: <a55d774e0910281922l2c84f7d5tdda6666878ece78a@mail.gmail.com>
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
From: Brian Swetland <swetland@google.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Greg KH <gregkh@suse.de>, Eric Miao <eric.miao@canonical.com>,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 6:55 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>>> But now, it is hard for us to do that without a workable Android drivers
>>> in mainline.
>>
>> Then push on Google to get them cleaned up and fixed!  Or do it
>> yourself, all I need is a developer to take ownership of the code.
>
> I'm doing a task which is trying to merge Android patches to Ubuntu kernel
> and mainline, not only the Android drivers but also the ARM port code which
> is not in mainline.
>
> But since Android kernel is 2.6.29 and ours or mainline is 2.6.31+, you know
> it needs much more effort without Google's help.
>
> And for sure, I'm very happy to help this out.

We (Google) definitely want to get back in sync with mainline (as I've
mentioned earlier in this or a related thread), and we're planning on
snapping up our kernel trees to 2.6.32+ once we get past various
deadlines in the near future.  Obviously action speaks louder than
words here, and I understand Greg's frustration at the slow pace so
far and appreciate his efforts to encourage us to stop dropping the
ball.

Probably the two biggest pain points for general driver support are
wakelocks (which we were making some progress on getting cleaned up on
the linux-pm list -- Arve will be respinning those patchsets for
review again before long) and some of the gpio support.  Otherwise,
most of the drivers don't have a lot of dependencies on new core
kernel infrastructure and many effectively stand alone.  For some of
the qualcomm chipsets, there is a fair bit of layering needed for
functions owned by the modem or dsp cores -- smem / smd / rpc / etc.

Brian
