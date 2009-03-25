Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZCYFL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZCYFL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZCYFLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:11:18 -0400
Received: from ozlabs.org ([203.10.76.45]:59330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZCYFLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:11:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nikanth Karthikesan <knikanth@novell.com>
Subject: Re: Strange code in include/linux/cpumask.h
Date: Wed, 25 Mar 2009 15:41:11 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: nikanth@gmail.com, linux-kernel@vger.kernel.org
References: <200903251021.13811.knikanth@novell.com>
In-Reply-To: <200903251021.13811.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251541.12180.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 15:21:13 Nikanth Karthikesan wrote:
> Hi Rusty
> 
> I do not understand this code.

Hi Nikanth,

   That's OK, it's a little tricky.

> The conditional operator would always evaluates to true and return bitmap. So 
> all it seems to does is
> #define to_cpumansk(bitmap) (struct cpumask *)(bitmap)

Yes, except that this insists that bitmap be an unsigned long * or you'll get
a warning.  Otherwise the macro could be used on anything.  And it needs to be
a macro to use it as a static initializer.

As the NR_CPUS bit arrays vanish, this macro will be used less and less; but
some of them will probably take a while.

Thanks for the question,
Rusty.
