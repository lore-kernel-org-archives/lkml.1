Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYC1MXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYC1MXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYC1MXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:23:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:46653 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYC1MXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Et0VhWzGB3pdY+25mb2ReDzUj7Q4a6AxCKKmZbs36CErSWDJAk7J/ycOHu9Zv7IdFixg6m2oCF9sbeeDApCCOQY1RUIqB4BqOl4TZItxEvB3jdEZJe+7+xO3K4TYFyMCX8cQm6QrXm9t2PVz9XIgi3btgDuB8RGVtJpzReeTZY8=
Message-ID: <47ECE318.1030809@gmail.com>
Date: Fri, 28 Mar 2008 13:22:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
References: <47ECD0CF.1020003@gmail.com> <87y783jdjo.fsf@basil.nowhere.org> <47ECD715.90507@gmail.com> <20080328113803.GQ29105@one.firstfloor.org>
In-Reply-To: <20080328113803.GQ29105@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2008 12:38 PM, Andi Kleen wrote:
> BTW i haven't audited them, but if there is u64 or similar in there anywhere
> be careful about alignment.

Well, not good, some ioctls have different numbers on 32 and 64 bit:
struct v4l2_ext_controls {
         __u32 ctrl_class;
         __u32 count;
         __u32 error_idx;
         __u32 reserved[2];
         struct v4l2_ext_control *controls;
};
#define VIDIOC_G_EXT_CTRLS      _IOWR ('V', 71, struct v4l2_ext_controls)
as an example.

And alignment is a problem here (v4l2_std_id is u64):
struct v4l2_standard {
         __u32                index;
         v4l2_std_id          id;
         __u8                 name[24];
         struct v4l2_fract    frameperiod; /* Frames, not fields */
         __u32                framelines;
         __u32                reserved[4];
};
which results in different ioctl numbers too.
