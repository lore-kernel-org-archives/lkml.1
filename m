Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZDNPGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZDNPGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZDNPF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:05:56 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:36138 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbZDNPF4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:05:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAHND5ElR8Pj5/2dsb2JhbACBUs52g3wG
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] uvcvideo: prevent invormation loss with removing implicit casting
Date: Tue, 14 Apr 2009 17:08:04 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <49DBDDB9.6020409@freemail.hu>
In-Reply-To: <49DBDDB9.6020409@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904141708.04870.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 01:11:53 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> The uvcvideo driver supports only one input, which is input 0. For all
> other input index the return value shall be EINVAL. This patch fixes the
> problem when the value 0x80000000 was incorrectly casted and treated as
> a zero value.
>
> The patch was tested with v4l-test 0.10 [2] with CNF7129 webcam found on
> EeePC 901.
>
> References:
> [1] V4L2 API specification, revision 0.24
>     http://v4l2spec.bytesex.org/spec/r11217.htm
>
> [2] v4l-test: Test environment for Video For Linux Two API
>     http://v4l-test.sourceforge.net/
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

> ---
> --- linux-2.6.29-git13/drivers/media/video/uvc/uvc_v4l2.c.orig	2009-04-06
> 23:16:06.000000000 +0200 +++
> linux-2.6.29-git13/drivers/media/video/uvc/uvc_v4l2.c	2009-04-08
> 00:37:01.000000000 +0200 @@ -648,7 +648,7 @@ static long
> uvc_v4l2_do_ioctl(struct fil
>
>  	case VIDIOC_S_INPUT:
>  	{
> -		u8 input = *(u32 *)arg + 1;
> +		u32 input = *(u32 *)arg + 1;
>
>  		if ((ret = uvc_acquire_privileges(handle)) < 0)
>  			return ret;

