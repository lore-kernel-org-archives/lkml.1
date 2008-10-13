Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYJMVuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYJMVuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYJMVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:49:53 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2296 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbYJMVtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:49:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Robert William Fuller <hydrologiccycle@gmail.com>
Subject: Re: [PATCH 2/2] video: simplify cx18_get_input() =?utf-8?q?and=09ivtv=5Fget=5Finput?=()
Date: Mon, 13 Oct 2008 23:49:06 +0200
User-Agent: KMail/1.9.9
Cc: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>,
       video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
References: <48F3B56E.9050404@freemail.hu> <200810132328.47170.hverkuil@xs4all.nl> <48F3C060.2050302@gmail.com>
In-Reply-To: <48F3C060.2050302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810132349.06834.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 October 2008 23:40:48 Robert William Fuller wrote:
> Hans Verkuil wrote:
> > On Monday 13 October 2008 22:54:06 Németh Márton wrote:
> >> From: Márton Németh <nm127@freemail.hu>
> >>
> >> The cx18_get_input() and ivtv_get_input() are called
> >> once from the VIDIOC_ENUMINPUT ioctl() and once from
> >> the *_log_status() functions. In the first case the
> >> struct v4l2_input is already filled with zeros,
> >> so doing this again is unnecessary.
> >
> > And in the second case no one cares whether the struct is zeroed.
> > And the same situation is also true for ivtv_get_output().
>
> Yeah, 'cos there's nothing better than uninitialized fields, like the
> recent report of a control that returns minimum and maximum values of
> zero, but a step-size of 9.  Why are we optimizing code paths that
> are not performance critical by uninitializing memory?

It's already initialized to 0 in v4l2-ioctl.c. No need to do it twice. 

Regards,

	Hans
