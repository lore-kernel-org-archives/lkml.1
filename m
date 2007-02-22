Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXBVUAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXBVUAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXBVUAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:00:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:24479 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXBVUAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JGyxJwkmTtqJS/I2L+HRcgjFlUuaduQ2mgaJtM9J8YXKmvFu5rQU6+2Tpoxdh6Tkxxvf2rTR9meCihX5M4NOliF51pygAohwm39NmwqHEF4/+ovSEcIRAKksdq8jX6vjLWVMtL58A1jFGCIkX2NWRKzcidWjPTxuyKzlmRiBp9I=
Date: Thu, 22 Feb 2007 15:00:06 -0500
From: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_io: fix race in master pty close/slave pty close path
Message-ID: <20070222200006.GP29690@cathedrallabs.org>
References: <20070222173744.GB6938@cathedrallabs.org> <45DDE862.2000100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DDE862.2000100@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Would another possible trace look like this?
> 
> idr_remove called for id=1 which is not allocated.
>  [<c0403f10>] dump_trace+0x69/0x1af
>  [<c040406e>] show_trace_log_lvl+0x18/0x2c
>  [<c04045e9>] show_trace+0xf/0x11
>  [<c0404673>] dump_stack+0x15/0x17
>  [<c04d3fcb>] idr_remove+0xe2/0x143
>  [<c051ee50>] release_dev+0x63b/0x652
>  [<c051ee6e>] tty_release+0x7/0xa
>  [<c0461b2e>] __fput+0xba/0x178
>  [<c045f466>] filp_close+0x52/0x59
(snip)

> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=211429
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227203
yeap, this patch may fix these too. Will build a test kernel with the
patch included and hand over to reporters to test.

-- 
Aristeu

