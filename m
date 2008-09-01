Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYIALVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYIALVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYIALUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:20:42 -0400
Received: from www.tglx.de ([62.245.132.106]:55337 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYIALUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:20:41 -0400
Date: Mon, 1 Sep 2008 13:20:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <mattjfleming@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ktime_set() does not check for nanoseconds > one second
In-Reply-To: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de>
References: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Matt Fleming wrote:
> 
> is it intentional that ktime_set() does not check whether the
> nanoseconds argument is greater than the number of nanoseconds in a
> second? I've run into a problem where a value of 1600000000
> nanoseconds was passed as an argument to ktime_set() and the return
> value was then used in a ktime_add() call, which returned an incorrect
> result. Should the caller of ktime_set() make this check or is it
> possible to move this logic in to the function itself?

Yeah, a check for this in ktime_set() might make sense. Currently it's
up to the programmer to provide sane values. :)

Thanks,

	tglx
