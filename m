Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYGRLXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYGRLXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYGRLXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:23:03 -0400
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:58638 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbYGRLXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:23:01 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 07:23:01 EDT
Message-ID: <48807821.8050504@swiss-it.ch>
Date: Fri, 18 Jul 2008 13:01:53 +0200
From: Reto Buerki <buerki@swiss-it.ch>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20071231)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: "core dump helper" runs always as root
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we run the usermode helper with the privileges of the dying process, what do 
> we do about rlimit enforcement?  They don't have a PAM environment, so either 
> they get the default rlimits, or we have to make them inherit their limits from 
> the dying process.  This is very problematic if the process died due to 
> exceeding an rlimit.

I'm not sure if I understand your objection correctly, but I thought
RLIMIT_CORE is ignored when using piped syntax with core_pattern.

At least this is how I interpret the code and the corresponding comment
in do_coredump() (fs/exec.c). The comment explicitly states that there's
no need to check RLIMIT_CORE value because file size limits and
permissions apply as they do with any other process.

There are also no further rlimit checks in usermode helper functions, at
least I could not find any ...

- reto



