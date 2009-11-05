Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZKEXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZKEXvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbZKEXvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:51:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZKEXvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:51:22 -0500
Message-ID: <4AF364F3.4070300@zytor.com>
Date: Thu, 05 Nov 2009 15:51:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: /proc/sys/kernel/pty/nr broken, possibly since 2.6.28
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed that /proc/sys/kernel/pty/nr is broken, and the most
likely culprit seems to be the series of checkins that include 8b0a88d5
and bf970ee4, during the 2.6.28 merge window.  This is thus a
regression.  I haven't verified that the bug really goes that far back
-- I should do a bisection -- but it is at least present in 2.6.30.9 and
2.6.32-rc6.

The symptom is that /proc/sys/kernel/pty/nr is properly increased, but
never decreased when a pty gets dropped.  It is in fact rather trivial
to escalate /proc/sys/kernel/pty/nr far above /proc/sys/kernel/pty/max.

As far as I read this series, the indent was to have this accounting
handled in pty_unix98_remove(), however, it would appear that that
function never gets called.  I'm wondering if this may be a symptom of a
bigger problem as well.

	-hpa
