Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYC1NcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYC1NcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYC1NcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:32:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40556 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYC1NcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:32:13 -0400
Date: Fri, 28 Mar 2008 14:35:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
Message-ID: <20080328133537.GS29105@one.firstfloor.org>
References: <47ECD0CF.1020003@gmail.com> <87y783jdjo.fsf@basil.nowhere.org> <47ECD715.90507@gmail.com> <20080328113803.GQ29105@one.firstfloor.org> <47ECE318.1030809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ECE318.1030809@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:22:48PM +0100, Jiri Slaby wrote:
> On 03/28/2008 12:38 PM, Andi Kleen wrote:
> >BTW i haven't audited them, but if there is u64 or similar in there 
> >anywhere
> >be careful about alignment.
> 
> Well, not good, some ioctls have different numbers on 32 and 64 bit:

Then you need compat handlers to translate the numbers.

> struct v4l2_ext_controls {
>         __u32 ctrl_class;
>         __u32 count;
>         __u32 error_idx;
>         __u32 reserved[2];
>         struct v4l2_ext_control *controls;

Definitely conversion needed for the pointer too.

> };
> #define VIDIOC_G_EXT_CTRLS      _IOWR ('V', 71, struct v4l2_ext_controls)
> as an example.
> 
> And alignment is a problem here (v4l2_std_id is u64):

Yes needs conversion for the structure too.

> struct v4l2_standard {
>         __u32                index;
>         v4l2_std_id          id;
>         __u8                 name[24];
>         struct v4l2_fract    frameperiod; /* Frames, not fields */
>         __u32                framelines;
>         __u32                reserved[4];
> };
> which results in different ioctl numbers too.

-andi

> 
