Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYCZAQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYCZAQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYCZAQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:16:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbYCZAQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:16:26 -0400
Date: Tue, 25 Mar 2008 17:16:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Marcus Better <marcus@better.se>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10327] New: keyboard stops responding after
 "ifdown eth0"
Message-Id: <20080325171608.509f4ca7.akpm@linux-foundation.org>
In-Reply-To: <47E99258.3060005@s5r6.in-berlin.de>
References: <bug-10327-10286@http.bugzilla.kernel.org/>
	<20080325143941.300d415f.akpm@linux-foundation.org>
	<47E9721C.2000306@better.se>
	<47E99258.3060005@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 01:01:28 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> One possible reason for unresponsive keyboard is a workqueue job in the 
> shared workqueue sleeping very long or indefinitely.
> 
> Sky2.c has only one workqueue job: sky2_restart().

Yeah.

Marcus, please try something like this:

- become root

- run

	( sleep 10 ; echo t > /proc/sysrq-trigger ) &
	ifdown eth0

- wait a minute or so

- reboot

- See if the sysrq-t output made it to /var/log/messages

  If it did, please send it as reply-to-all to this email.  Try to avoid
  wordwrapping it, as many do.

Thanks.
