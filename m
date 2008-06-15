Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYFORLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYFORLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 13:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbYFORLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 13:11:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59175 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbYFORLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 13:11:21 -0400
Date: Sun, 15 Jun 2008 19:11:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: path to speakup control variables?
In-Reply-To: <20080615164422.GS4770@implementation>
Message-ID: <alpine.LNX.1.10.0806151907590.22495@fbirervta.pbzchgretzou.qr>
References: <20080615164422.GS4770@implementation>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-06-15 18:44, Samuel Thibault wrote:
>Hello,
>
>The speakup module used to put of its control variables (e.g. speech
>speed) in /proc/speakup/ . To better stick with common practice,
>should that go to somewhere in /sys or in /proc/sys/speakup (though
>it looked to me like non-mainstream modules can't go there because of
>sysctl_check)?

For some tasks, neither procfs nor sysfs seem to be the right place.
Which is really odd. The two unwritten rules are

(a) "No new files should go into /proc"

 -> so we use sysfs, we would think

(b) "/sys files have only one value"

 -> that's possibly expensive in terms of dentries and kobjects
    when you think of files with lots of variables like /proc/stat

So we're in a draw for some sort of files...
