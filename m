Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZKFBEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZKFBEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbZKFBEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:04:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZKFBEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:04:07 -0500
Message-ID: <4AF37600.9030706@zytor.com>
Date: Thu, 05 Nov 2009 17:04:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: /proc/sys/kernel/pty/nr broken, possibly since 2.6.28
References: <4AF364F3.4070300@zytor.com>
In-Reply-To: <4AF364F3.4070300@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2009 03:51 PM, H. Peter Anvin wrote:
> I just noticed that /proc/sys/kernel/pty/nr is broken, and the most
> likely culprit seems to be the series of checkins that include 8b0a88d5
> and bf970ee4, during the 2.6.28 merge window.  This is thus a
> regression.  I haven't verified that the bug really goes that far back
> -- I should do a bisection -- but it is at least present in 2.6.30.9 and
> 2.6.32-rc6.
> 
> The symptom is that /proc/sys/kernel/pty/nr is properly increased, but
> never decreased when a pty gets dropped.  It is in fact rather trivial
> to escalate /proc/sys/kernel/pty/nr far above /proc/sys/kernel/pty/max.
> 
> As far as I read this series, the indent was to have this accounting
> handled in pty_unix98_remove(), however, it would appear that that
> function never gets called.  I'm wondering if this may be a symptom of a
> bigger problem as well.
> 

Bisection confirms that the bug was introduced during this commit series:

There are only 'skip'ped commit left to test.
The first bad commit could be any of:
8b0a88d5912ab549d5adac2c8498ecdaae5319a5
73ec06fc5f5c8e1097a7a4a4ab2d7c6c3a007e81
7d7b93c1452f381350dbaf276a63357fa6559e6d
bf970ee46e0fb363c8df4393229121d54330a98e
We cannot bisect more!

This series of skipped commits are ones during which
/proc/sys/kernel/pty doesn't exist at all.

	-hpa
