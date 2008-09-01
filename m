Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYIAUtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYIAUtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYIAUtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:49:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:57024 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYIAUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FljkkfNqAvb4Iu7TFcRR6gj1acT8u6kbDaPWiw8NMuT1GVfeYS/cT20g8on1pUfvrH
         GHkbTA651xc05pGch5lq2WjY6pzrYNu6cbkUTsP5EQ0ad0hsS8/rNVLV0hqoo0/5V02v
         25NrhaMqgBMUUK9zXGMcbdTvBcXDQMFyWjnF8=
Message-ID: <21d7e9970809011349w66cdeca3hf0f6cb544e586a71@mail.gmail.com>
Date: Tue, 2 Sep 2008 06:49:34 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Cc: "Jean Delvare" <khali@linux-fr.org>,
       "Gene Heskett" <gene.heskett@verizon.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>, xorg@lists.freedesktop.org,
       davem@davemloft.net, torvalds@linux-foundation.org, nhaehnle@gmail.com,
       airlied@linux.ie, glisse@freedesktop.org, tony@bakeyournoodle.com
In-Reply-To: <3f9a31f40809011140t5c69b62ci41f20a306bb4a7f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808301452.04634.gene.heskett@verizon.net>
	 <3f9a31f40809010934k468914d8sc43f323e9f32e9e7@mail.gmail.com>
	 <20080901195225.3dcc50bc@hyperion.delvare>
	 <3f9a31f40809011140t5c69b62ci41f20a306bb4a7f1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 4:40 AM, Jaswinder Singh
<jaswinderlinux@gmail.com> wrote:
> Hello Jean,
>
> On Mon, Sep 1, 2008 at 1:52 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> On Mon, 1 Sep 2008 12:34:28 -0400, Jaswinder Singh wrote:
>>> Hello Gene,
>>>
>>> On Sat, Aug 30, 2008 at 2:52 PM, Gene Heskett <gene.heskett@verizon.net> wrote:
>>> >
>>> > A re-repeat of a previous posting which has not drawn a comment. With added
>>> > content, added CC to a patch author, and some new questions.
>>> >
>>>
>>> This is not because of my radeon firmware patch, my patch is still in
>>> pipeline. Here is the list of developers who played with radeon :-
>>>
>>> 1. 4 days ago         Linus Torvalds  Merge branch 'drm-patches' of
>>> git://git.kernel.org ...
>>> 2. 7 days ago         Nicolai Haehnle         drm/radeon: r300_cmdbuf: Always emit
>>> INDX_BUFFER immediately ...
>>> 3. 7 days ago         Jerome Glisse   radeon: fix some hard lockups on r3/4/500s
>>> 4. 2008-08-12         David Miller    radeonfb: fix accel engine hangs
>>> 5. 2008-08-05         Jean Delvare    radeonfb: give i2c buses nicer names
>>> 6. 2008-08-05         David Miller    radeon: misc corrections
>>> 7. 2008-07-24         Tony Breeds     drivers/video/aty/radeon_base.c: notify
>>> user if sysfs ...
>>
>> radeonfb != drm/radeon
>>
>
> yes you are right.
>
> Sorry, to disturb other guy. Messages are coming from :
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=54f961a628b737f66710eca0b0d95346645dd33e
>
> Jerome Glisse and Dave Airlie :
>
> +       DRM_INFO("wait for fifo failed status : 0x%08X 0x%08X\n",
> +                RADEON_READ(RADEON_RBBM_STATUS),
> +                RADEON_READ(R300_VAP_CNTL_STATUS));
>
> +       DRM_INFO("wait idle failed status : 0x%08X 0x%08X\n",
> +                RADEON_READ(RADEON_RBBM_STATUS),
> +                RADEON_READ(R300_VAP_CNTL_STATUS));
>
> what is the idea of printing R300 STATUS on R200 code or common code ?
>
> Please let me know what is the solution of R200 problem ?
>

I've already submitted patches to Linus to downgrade the warning for
now, reading the r300 on r200 doesn't matter at all,

Finding the reason for the FIFO stalls on r200 requires further
investigation, it apparently has been happening for "ever",
we just never printed the debug before.

Dave.
