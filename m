Return-Path: <linux-kernel-owner+w=401wt.eu-S1032880AbXEIACA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032880AbXEIACA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032808AbXEIABp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:01:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:41220 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032804AbXEIABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=O5jQXrIUuKLZGak5/hz7s4e1dlFhW/pLeKJXLlujtrav1B21CdvBSn7TBTqmO1uIbUe/VYgVjh6lzIR0VX6qilFMmTimETvyrYHX1FaTF0G8a33bp0tKRCL6JZuinGk5gseIzzZNFmKgm2DWCR9gHLu3XUYAUiNKc+RTSaHl1oQ=
Message-ID: <75b66ecd0705081701n414c29f7r74b0e4836798393a@mail.gmail.com>
Date: Tue, 8 May 2007 20:01:42 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: Preempt of BKL and with tickless systems
Cc: "Linux Kernel mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4640E64D.3070304@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4640E64D.3070304@tmr.com>
X-Google-Sender-Auth: 86c98d61ac2d2a00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Bill Davidsen <davidsen@tmr.com> wrote:
> I think I have a reasonable grip on the voluntary and full preempt
> models, can anyone give me any wisdom on the preempt of the BKL? I know
> what it does, the question is where it might make a difference under
> normal loads. Define normal as servers and desktops.

This was introduced by Ingo to solve a real problem that I found,
where some codepath would hold the BKL for long enough to introduce
excessive scheduling latencies - search list archive for details.  But
I don't remember the code path (scrolling the FB console?  VT
switching? reiser3?  misc. ioctl()s?).  Basically, taking the BKL
disabled preemption which caused long latencies.

It's certainly possible that whatever issue led to this was solved in
another way since.

Lee
