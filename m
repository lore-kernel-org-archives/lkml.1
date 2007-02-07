Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXBGPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXBGPty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 10:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030637AbXBGPty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 10:49:54 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:62654 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030634AbXBGPty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 10:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cyuI2Ru4a6heUJ9zWSFLiDlFZg4DnFmXkCJpldw0fc/sRR6HjBegCdSTpp0phKRWDttncsTxez6GctOzHgvqGeFnkzWurcvqbdpdSR0aQ3sM3GGsiXJFr3dl9y7XMC5zygAf5m+HfmKrYP5rFrMAkuQUpunTace4t10aQGrxqjo=
Message-ID: <a80eebd40702070749t103c2b5qa8ac627eb997056d@mail.gmail.com>
Date: Wed, 7 Feb 2007 10:49:53 -0500
From: "Sen Horak" <sen.horak@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Performance of concurrent senders
In-Reply-To: <a80eebd40702061251v54153e7ficdae109111c91a27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a80eebd40702061251v54153e7ficdae109111c91a27@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi --

I have been running some experiments involving processes sending large
volumes of data concurrently. The results show (on Linux 2.6.19.2)
that although the total throughput achieved by all the processes
remains constant, the jitter increases as the number of processes
increases. Beyond about 64 processes (on a 2.4GHz Xeon with 4Mb of
cache), processes start getting starved and the streams get very
bursty.

Are there any steps one can take to make the jitter scale better, eg.
by using another scheduler? I guess that it is reasonable that the
jitter grow with added contention through the TCP/IP stack - but what
growth rate is acceptable? Is the data I have below reasonable?

The jitter varies as follows and is shown as an average+/- sd across
25 10-second intervals.

Concurrency            Jitter (us)

1                               1.6+/-0.8
2                               1.5+/-1.1
4                               1.4+/-0.6
8                               0.8+/-0.5
12                             2.3+/-1.2
16                             3.3+/-2.1
20                             4.6+/-2.5
24                             6.2+/-1.4
28                             7.8+/-3.2
32                             10.0+/-3.4
64                             100+

Sen
